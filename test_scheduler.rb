require './scheduler.rb'

emp = [{name: 'Jack', role: :cook, avail: [[[6, 12], [15, 22]],
                                           [[5, 22]],
                                           [[3, 12], [14, 22]],
                                           [[3, 22]],
                                           [[3, 22]],
                                           [[3, 22]],
                                           [[3, 22]]]
       },
       {name: 'Wayne', role: :cook, avail: [[[6, 12], [15, 22]],
                                            [[5, 22]],
                                            [[3, 12], [14, 22]],
                                            [[3, 22]],
                                            [[3, 22]],
                                            [[3, 22]],
                                            [[3, 22]]]
       },
       {name: 'Emily', role: :janitor, avail: [[[6, 12], [15, 22]],
                                               [[5, 22]],
                                               [[3, 12], [14, 22]],
                                               [[3, 22]],
                                               [[3, 22]],
                                               [[3, 22]],
                                               [[3, 22]]]
       },
       {name: 'Francis', role: :server, avail: [[[6, 12]],
                                                [[5, 22]],
                                                [[3, 22]],
                                                [[3, 22]],
                                                [[3, 22]],
                                                [[3, 22]],
                                                [[3, 22]]]
       },
       {name: 'Trent', role: :server, avail: [[[6, 12]],
                                              [[5, 22]],
                                              [[3, 22]],
                                              [[3, 22]],
                                              [[3, 22]],
                                              [[3, 22]],
                                              [[3, 22]]]
       },
       {name: 'Hans', role: :server, avail: [[[6, 12]],
                                             [[5, 22]],
                                             [[3, 22]],
                                             [[3, 22]],
                                             [[3, 22]],
                                             [[3, 22]],
                                             [[3, 22]]]
       }


      ]
shifts = [
  [{time: [9, 11], cook: 1, server: 2, janitor: 1},
   {time: [13, 14], cook: 2, server: 3, janitor: 1},
   {time: [14, 17], cook: 1, server: 2}],
  [{time: [6, 10], cook: 2, janitor: 2, server: 3},
   {time: [10, 15], cook: 2, server: 2},
   {time: [14, 18], cook: 3, server: 3},
   {time: [17, 21], cook: 3, server: 3}],
  [{time: [11, 15], cook: 1},
   {time: [10, 15], cook: 1, server: 2}],
  [{time: [11, 15], cook: 1}],
  [{time: [11, 15], cook: 1}],
  [{time: [11, 15], cook: 1},
   {time: [10, 15], cook: 1, server: 2}],
  [{time: [11, 15], cook: 1}]
]

s = Schedule.new(emp, shifts)
s.init
p s.avail_table
s.evolution
p s.schedule
