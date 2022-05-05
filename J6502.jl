# 6502 Emulator in Julia
# Michael Doornbos (mike@imapenguin.com)

using OffsetArrays

MAX_MEMORY=2^16 # Use this for zero based arrays

mutable struct Cpu6502
    pc::UInt16  # program counter
    sp::UInt8   # stack pointer  
    # cpu sets stack to 0xff on power up, but effectively adds
    # 0x100 because the stack area is 0x100 to 0x1ff 
    a::UInt8    # A register
    x::UInt8    # X Register
    y::UInt8    # Y Register
    p::UInt8    # Status flags
    # memory::OffsetVector
    ##################
    # Status flags
    #   bit Flag
    #   7   N Negative
    #   6   V oVerflow
    #   5   --
    #   4   B Break
    #   3   D Decimal
    #   2   I Interrupt
    #   1   Z Zero
    #   0   C Carry 
    ###################
    function Cpu6502()
        new(0xfffc,0xff,0x00,0x00,0x00,0x00)
    end
end

function resetCpu(cpu6502::Cpu6502)
    cpu6502.pc = 0xfffc
    cpu6502.sp = 0xff 
    
end 

function monitor(cpu)
    println("PC: $(string(cpu.pc; base=16)) SP:$(string(cpu.sp; base=16)) A:$(string(cpu.a; base=16)) X:$(string(cpu.x; base=16)) Y:$(string(cpu.y; base=16)) P:$(bitstring(cpu.p))\n")
end


function execute(cpu, memory, cycles)
    
    while cycles > 0   
       data = memory[cpu.pc]
       cpu.pc += 1
       cycles -= 1
    end
    printhex(cpu.pc)
end

function printhex(val)
    print(string(val; base=16))
end
### Main

function main()
    println("JULIA 6502 EMULATOR\n\n")
    mycpu = Cpu6502()

    mymemory = OffsetVector(zeros(UInt8,MAX_MEMORY), 0:MAX_MEMORY-1)
    resetCpu(mycpu)
    monitor(mycpu)
    @show mycpu.pc
    mymemory[0xffff] = 0xca
    @show mymemory[0x0000]
    @show mymemory[0xffff]
    mymemory[0xffff] = 0xca + 0xff
    mymemory[0xfffc] = 0xea
    mymemory[0xfffd] = 0xbb
    @show mymemory[0xffff]
    monitor(mycpu)
    execute(mycpu,mymemory,2)
    @show mymemory[mycpu.pc]
    
    
end


main()

