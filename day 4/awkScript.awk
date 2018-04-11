
 BEGIN {

    seqno = 0; 

    droppedPackets = 0;

    receivedPackets = 0;

    count = 0;
    i = 0;
    j = 0;

    action_node = $3
    #transmitting energy
    intial_energy = 100
    #number of nodes
    total_energy_consumed = 0
    #num_of_sources = 2
    num_of_sources = 50
    }

    {
    # Trace line format: energy
    event = $1
    time = $2
    if (event =="N"){
    remaining_energy[$5] = $7
 
     #packet delivery ratio
    }
    if($4 == "AGT" && $1 == "s") {

   seqno++;

   } else if(($4 == "AGT") && ($1 == "r")) {

   receivedPackets++;

   } else if ($4 == "AGT" && $1 == "d"){

   droppedPackets++; 

   }

   #end-to-end delay

   if(($4 == "AGT") && ($1 == "s")) {

   start_time[i] = $2;
   i++;
  

   } else if(($4 == "AGT") && ($1 == "r")) {

   end_time[j] = $2;
   j++;
  

   } else if(($4 == "AGT") && ($1 == "d")){

   end_time[$35] = -1;

   }

   }

    

   END { 

   for(i=0; i<seqno; i++) {

   if(end_time[i] > 0) {
   delay[i] = end_time[i] - start_time[i];
#   print "p=" delay[i];
   count++;

   }

   else

   {

   delay[i] = -1;

   }

   }

   for(i=0; i<count; i++) {

   if(delay[i] > 0) {

   n_to_n_delay = n_to_n_delay + delay[i];

   } 

   }
   print "Average End-to-End Delay = " n_to_n_delay;
   n_to_n_delay = n_to_n_delay/count;

   print "\n";

   print "GeneratedPackets = " seqno;

   print "ReceivedPackets = " receivedPackets;
	
   print "Packet Delivery Ratio = " receivedPackets/(seqno)*100"%";
   
   print "Average End_to_End Delay = " n_to_n_delay;
   print "Average End-to-End Delay = " n_to_n_delay * 1000 " ms";

   print "\n";

   ###compute average energy
    #total_energy_consumed = num_of_sources * intial_energy - ( remaining_energy[16] + remaining_energy[19])
    total_energy_consumed = num_of_sources * intial_energy - ( remaining_energy[19])
    Total_average_energy_per_node = total_energy_consumed / num_of_sources
    ####output
    print "\n";
    print("Average energy per node in joules : ",Total_average_energy_per_node)
    print "\n";


    print Total_average_energy_per_node, " ", n_to_n_delay * 1000, 
" ",receivedPackets/(seqno)*100;
 }
