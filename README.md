# cover_on_any_event
* Title       : Coverage on Multiple Events  
* Version     : 1.0
* Requires    : Specman {19.06..}
* Modified    : January 2020
* Description :

[ More e code examples in https://github.com/efratcdn/spmn-e-utils ]



Define a coverage group as to be sampled on multiple events.


When the requirement is to cover on any event in a list, then starting 
Specman 19.03 no need for special utility. Use the "on with any" to define
an event that is emitted when any of the events in the list are emitted.

See the usage example in cover_on_any_event.

   specman -c 'load cover_on_any_event;test;show cover env.any_event_power_off;sys.env.event_count()'



When the requirement is to sample upon various different events, you might
prefer to use the event callback.

e_util_cover_mult_events.e implements an event callback, that samples the 
required coverage group, upon events emission.

Using this utility:

   1) import e_util_cover_mult_events.e
   2) Instantiate the sample_upon_event_callback
        Assign its fields:
            .cover_container : reference to containing unit
            .event_name      : string, <unit name>_<event name>
   3) Register all events you want to trigger the cover sampling
 

For example:

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


Demo:

specman -c 'load cover_mult_events_usage_ex;test;show cover env.any_event_power_off;sys.env.event_count()'
