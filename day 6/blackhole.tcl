set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     3                          ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      100                        ;# X dimension of topography
set val(y)      100                        ;# Y dimension of topography
set val(stop)   100.0                      ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open blackhole.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open blackhole.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      OFF \
                -movementTrace ON

#===================================
#        Nodes Definition        
#===================================
#Create 3 nodes
set n0 [$ns node]
$n0 set X_ 200
$n0 set Y_ 100
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n2 [$ns node]
$n2 set X_ 250
$n2 set Y_ 250
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n1 [$ns node]
$n1 set X_ 200
$n1 set Y_ 400
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20

# Node 5 is given RED Color and a label- indicating it is a Blackhole Attacker
$n2 color red
$ns at 0.0 "$n2 color red"
$ns at 0.0 "$n2 label Attacker"

# Node 0 is given GREEN Color and a label - acts as a Source Node
$n0 color green
$ns at 0.0 "$n0 color green"
$ns at 0.0 "$n0 label Source"

# Node 3 is given BLUE Color and a label- acts as a Destination Node
$n1 color blue
$ns at 0.0 "$n1 color blue"
$ns at 0.0 "$n1 label Destination"

#===================================
#    	Set node 5 as attacker    	 
#===================================
$ns at 0.0 "$n2 set ragent_ hacker"

#===================================
#        Agents Definition        
#===================================
#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0
$udp0 set packetSize_ 1500

set udp01 [new Agent/UDP]
$ns attach-agent $n1 $udp01
set null01 [new Agent/Null]
$ns attach-agent $n0 $null01
$ns connect $udp01 $null01
$udp01 set packetSize_ 1500

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n2 $null1
$ns connect $udp1 $null1
$udp1 set packetSize_ 1500

set udp11 [new Agent/UDP]
$ns attach-agent $n2 $udp11
set null11 [new Agent/Null]
$ns attach-agent $n1 $null11
$ns connect $udp11 $null11
$udp11 set packetSize_ 1500

set udp2 [new Agent/UDP]
$ns attach-agent $n2 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n0 $null2
$ns connect $udp2 $null2
$udp2 set packetSize_ 1500

set udp21 [new Agent/UDP]
$ns attach-agent $n0 $udp21
set null21 [new Agent/Null]
$ns attach-agent $n2 $null21
$ns connect $udp21 $null21
$udp21 set packetSize_ 1500
#===================================
#        Applications Definition        
#===================================
#Setup a CBR Application over UDP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 0.1Mb
$cbr0 set random_ null
$ns at 1.0 "$cbr0 start"
$ns at 100.0 "$cbr0 stop"

set cbr01 [new Application/Traffic/CBR]
$cbr01 attach-agent $udp01
$cbr01 set packetSize_ 1000
$cbr01 set rate_ 0.1Mb
$cbr01 set random_ null
$ns at 1.0 "$cbr01 start"
$ns at 100.0 "$cbr01 stop"

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 0.1Mb
$cbr1 set random_ null
$ns at 1.0 "$cbr1 start"
$ns at 100.0 "$cbr1 stop"

set cbr11 [new Application/Traffic/CBR]
$cbr11 attach-agent $udp11
$cbr11 set packetSize_ 1000
$cbr11 set rate_ 0.1Mb
$cbr11 set random_ null
$ns at 1.0 "$cbr11 start"
$ns at 100.0 "$cbr11 stop"

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set packetSize_ 1000
$cbr2 set rate_ 0.1Mb
$cbr2 set random_ null
$ns at 1.0 "$cbr2 start"
$ns at 100.0 "$cbr2 stop"

set cbr21 [new Application/Traffic/CBR]
$cbr21 attach-agent $udp21
$cbr21 set packetSize_ 1000
$cbr21 set rate_ 0.1Mb
$cbr21 set random_ null
$ns at 1.0 "$cbr21 start"
$ns at 100.0 "$cbr21 stop"

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    #exec nam blackhole.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run