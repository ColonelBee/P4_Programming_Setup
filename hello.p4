#include <core.p4>
#include <v1model.p4>

// Define an empty header
header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

// Metadata (empty for now)
struct metadata_t { }
struct headers_t {
    ethernet_t ethernet;
}

// Parser
parser MyParser(packet_in packet,
                out headers_t hdr,
                inout metadata_t meta,
                inout standard_metadata_t stdmeta) {
    state start {
        packet.extract(hdr.ethernet);
        transition accept;
    }
}

// VerifyChecksum (dummy)
control MyVerifyChecksum(inout headers_t hdr, inout metadata_t meta) {
    apply { }
}

// Ingress
control MyIngress(inout headers_t hdr,
                  inout metadata_t meta,
                  inout standard_metadata_t stdmeta) {
    apply { }
}

// Egress
control MyEgress(inout headers_t hdr,
                 inout metadata_t meta,
                 inout standard_metadata_t stdmeta) {
    apply { }
}

// ComputeChecksum (dummy)
control MyComputeChecksum(inout headers_t hdr, inout metadata_t meta) {
    apply { }
}

// Deparser
control MyDeparser(packet_out packet,
                   in headers_t hdr) {
    apply {
        packet.emit(hdr.ethernet);
    }
}

// Main package
V1Switch(
    MyParser(),
    MyVerifyChecksum(),
    MyIngress(),
    MyEgress(),
    MyComputeChecksum(),
    MyDeparser()
) main;
