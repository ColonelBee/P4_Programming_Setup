# P4_Programming_Setup
### This is the repository that tests and sets up P4 program as well as P4RunTime controller.
### The repo is still in progress (updated 25/9)
First of all create a new .p4 file in a directory called p4projects:

```bash
  mkdir p4projects
  cd ./p4projects
  touch hello.p4
```
#### I. Using docker container for p4c compiler
1. Pull the official P4 compiler image
```bash
  docker pull p4lang/p4c:latest
```
2. Direct to your directory that holds your hello.p4 program and run the Docker p4c container
```bash
  cd p4projects
  docker run -it --rm --privileged --network host -v $(pwd):/work p4lang/p4c:latest bash
```
3. Inside the container, redirect to your pwd mounted on /work
```bash
  cd /work
```
4. Next, compile your P4 code
```bash
  p4c -b bmv2 --p4runtime-files build/hello.p4info.txtpb hello.p4 -o build
```
At this point, you might get the error while loading shared libraries: libboost_iostreams.so.1.71.0: cannot open shared object file: No such file or directory. To fix, install the libboost-iostreams1.71.0
```bash
  apt-get update && apt-get install -y libboost-iostreams1.71.0
```
Then, try to compile your P4 program again.

Now, you should see hello.p4 and a directory named build if your code doesn't have bugs.

Inside the build directory, you should see these files as follows:

```bash 
  hello.json   hello.p4i   hello.p4info.txt   hello.p4info.txtpb
```
#### II. Using docker container for BMv2 switch
1. Pull the official behavioral-model image
```bash
  docker pull p4lang/behavioral-model
```
2. Run the Docker container for behavioral-model
```bash
  docker run -it --rm --privileged --network host -v $(pwd):/work p4lang/behavioral-model:latest bash
```
3. Inside the container, redirect to your pwd mounted on /work
```bash
  cd /work
```
4. Check your simple_switch_grpc version, and run the simple_switch_grpc
```bash
  simple_switch_grpc --version
  simple_switch_grpc --device-id 0 --log-console build/hello.json
```
After that, you might get the result as shown below:
```bash
  Calling target program-options parser
  Server listening on 0.0.0.0:9559
```
You must let the switch on when you upload rules from P4Runtime Controller! 

Ctrl + C to turn the switch off.

#### III. P4Runtime Controller
You can either use p4runtime-sh or Python script to add rules to the simple_switch, but this repo will focus on Python script
```bash
  git clone https://github.com/protocolbuffers/protobuf.git
  cd p4runtime/proto
  pip install protobuf==3.20.* --break-system-packages
  python3 -m grpc_tools.protoc -I. -I(your_home_dir)/p4c/control-plane --python_out=. --grpc_python_out=. p4/v1/p4runtime.proto
```
You can see your home directory through
```bash
  echo $HOME
```
Now you can check
```bash
  python3
  >>> import p4.v1.p4runtime_pb2
  >>> import p4.v1.p4runtime_pb2_grpc
```
If no error shows up, you have successfully installed P4Runtime!
#### IV. Testing the interaction of P4Runtime and the simple_switch_grpc
Make sure that the simple_switch is ON as stated in section II
Make a Python file, and run the code in ... (updating)
