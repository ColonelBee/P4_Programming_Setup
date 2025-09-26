#!/usr/bin/env python3
import grpc
from p4.v1 import p4runtime_pb2
from p4.v1 import p4runtime_pb2_grpc

def main():
    # 1. Connect to BMv2 P4Runtime server
    channel = grpc.insecure_channel('localhost:9559')
    stub = p4runtime_pb2_grpc.P4RuntimeStub(channel)

    # 2. Build a simple CapabilitiesRequest
    request = p4runtime_pb2.CapabilitiesRequest()

    try:
        response = stub.Capabilities(request)
        print("Connected to BMv2 P4Runtime server")
        print("P4Runtime API version:", response.p4runtime_api_version)
    except grpc.RpcError as e:
        print("Could not connect to BMv2")
        print("Error:", e)

if _name_ == "_main_":
    main()
