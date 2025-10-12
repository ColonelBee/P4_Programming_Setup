# P4_Programming_Setup
### This is the repository that tests and sets up P4 program as well as P4RunTime controller.
### The repo is still in progress (updated 12/10)
First of all create a new .p4 file in a directory called p4projects

```bash
  mkdir p4projects
  cd ./p4projects
  touch hello.p4
```
You can take the P4 code to test from [hello.p4](https://github.com/ColonelBee/P4_Programming_Setup/blob/main/hello.p4)
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

#### III. P4Runtime Controller
Install P4Runtime shell via pip3
```bash
  # Install p4runtime-shell package and run it
  pip3 install p4runtime-shell --break-system-packages
  python3 -m p4runtime_sh --grpc-addr <server IP>:<server port> \
    --device-id 0 --election-id 0,1 --config <p4info.txt>,<pipeline config>
```

Now you can check if there is a line like
```bash
  *** Welcome to the IPython shell for P4Runtime ***
```
then you are good to go.
If no error shows up, you have successfully installed P4Runtime!
#### IV. Testing the interaction of P4Runtime and the simple_switch_grpc via Python script
Make sure that the simple_switch_grpc is ON as stated in section II.

Create a Python file, and run the test code from [test_P4.py](https://github.com/ColonelBee/P4_Programming_Setup/blob/main/test_P4.py) in another terminal.

If the result shows the connection successfully, that means the connection is good.
