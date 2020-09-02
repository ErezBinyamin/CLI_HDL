# MAC_Unit
Intro to GHDL with a basic Multiply and Accumulate with Build in Self Test (BIST)

## Prerequisite packages install script
```
sudo apt update
sudo apt install -y git make gnat zlib1g-dev
git clone https://github.com/ghdl/ghdl
cd ghdl
./configure --prefix=/usr/local
make
sudo make install
echo "$0: All done!"
sudo apt install gtkwave
```

## Clone project and test design
```
git clone https://github.com/ErezBinyamin/MAC_Unit.git
cd MAC_Unit
./simulate
```

## Test intermediary structures
- N-bit adder: ```./simulate 1```  
- N-bit Multiplier: ```./simulate 2```  
- MAC unit: ```./simulate 3```  
- BIST-MAC ```./simulate 4```  

## GTK-wave simulation output
![output](report/gtkwave_output.png)
