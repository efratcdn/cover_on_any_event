
  e_util_cover_mult_events.e
 
  Defines an event callback struct.
  
  When any of the registered events is triggered - the do_callback()
  is called, and the cover group will be sampled
  
  
<'
struct sample_upon_event_callback like event_callback_struct {
    !cover_container : any_struct;
    !event_name      : string;
    
    do_callback() is only {
        covers.sample_cg(event_name, cover_container);
    };
};
'>
