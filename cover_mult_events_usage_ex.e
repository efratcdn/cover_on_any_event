cover_mult_events_usage_ex.e
  
  The env.any_event_power_off cover group should be sampled when any
  of the agents' power_off event is emitted, and also when env.power_off
  event is emitted, and also when the env.power event_port is emitted.
  
  
  For each event or event_port we want to trigger the sampling of the
  any_event_power_off cover group - register it to sample_upon_event_callback.

  
<'
import e_util_cover_mult_events.e;

unit agent {
    !event_counter : uint;
    event power_off;
    on power_off {event_counter += 1};
};

type env_state_t : [PHASE_0, PHASE_1, PHASE_2, PHASE_3];

unit env {
    agents[4] : list of agent is instance;
    state     : env_state_t;
    off_p     : in event_port is instance;
    event power_off;
    event off_event_port is @off_p$;
    
    // Has to be sampled when any of multiple events are triggered
    event any_event_power_off;
    cover any_event_power_off is {
        item state;
    };
    
    
    // Using the event callback
    !sample_upon_event_callback : sample_upon_event_callback;
    
    post_generate() is also {
        sample_upon_event_callback = new with {
            .cover_container = me;
            .event_name = "env.any_event_power_off";
        };
        sample_upon_event_callback.register_with_event(me, "power_off");
        for each in agents{
            sample_upon_event_callback.register_with_event(it, "power_off");
        };
        sample_upon_event_callback.register_with_event_port(off_p);
    };
    
    
    event_count() is {
        out("\nThe various events weres emitted, totally, ",
            sys.events_counter, "\nso expecting to see ",
            sys.events_counter,
            " samples of the any_event_power_off cover group\n");
    };
    
    check() is also {
        event_count();
    };
};

extend sys {
    env    : env is instance;
    
    
    // Following is for creating some scenario, triggering events
    off_p  : out event_port is instance;
    !events_counter : uint;
    
    connect_ports() is also {
        do_bind(off_p, env.off_p);
    };
    dummy_scenario()@any is {
        var agent_index : int;
        
        raise_objection(TEST_DONE);
        for i from 0 to 2 {
            wait cycle;
            env.state = PHASE_0;
            gen agent_index keeping {it in [0..3]};
            emit env.agents[agent_index].power_off;
            events_counter += 1;
            wait cycle;
            env.state = PHASE_1;
            emit env.power_off;
            events_counter += 1;
            wait cycle;
            env.state = PHASE_2;
            emit off_p$;
            events_counter += 1;
        };
        wait cycle;
        drop_objection(TEST_DONE);
    };
    
    run() is also {
        start dummy_scenario();
    };
};
'>

