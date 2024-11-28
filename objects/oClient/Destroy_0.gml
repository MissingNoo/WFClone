//feather disable all
if (variable_instance_exists(self, "keepalive") and time_source_exists(keepalive)) {
    time_source_destroy(keepalive); 
}