
  cover_on_any_event.e
  
  The env.any_event_power_off cover group should be sampled when any
  of the agents' power_off event is emitted.
  
  In order to do so, we emit the event any_event_power_off on emission 
  of any of the agents power_off event:
  
    on agents[i].power_off with any i {
        emit any_event_power_off;
    };
  
<'

unit agent {
    !event_counter : uint;
    event power_off;
    on power_off {event_counter += 1};
};

type env_state_t : [PHASE_0, PHASE_1, PHASE_2, PHASE_3];

unit env {
    agents[4] : list of agent is instance;
    state     : env_state_t;
    
    event any_event_power_off;
    cover any_event_power_off is {
        item state;
    };
    
    on agents[i].power_off with any i {
        emit any_event_power_off;
    };
    
    event_count() is {
        out("\nThe power_off event was emitted, totally in all agents, ",
            agents.event_counter.sum(it), "\nso expecting to see ",
            agents.event_counter.sum(it),
            " samples of the any_event_power_off cover group\n");
    };
    
    check() is also {
        event_count();
    };
};

extend sys {
    env : env is instance;
    
    dummy_scenario()@any is {
        var agent_index : int;
        
        raise_objection(TEST_DONE);
        for i from 0 to 5 {
            wait cycle;
            gen env.state;
            gen agent_index keeping {it in [0..3]};
            emit env.agents[agent_index].power_off;
        };
        drop_objection(TEST_DONE);
    };
    
    run() is also {
        start dummy_scenario();
    };
};
'>
