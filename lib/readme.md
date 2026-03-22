# so the thing is development branch will print as much info as possible in the console to help debugging

# most function or process will have there own debug identifier string prefixed by "debug_print"

# formated like this "debug_print_${function_name}"

# sub_processes could be searched on console too like "debug_print_${function_name}-${sub_function_name}"

# values may acompany the print out too like "debug_print_${function_name}-${sub_function_name}-${observed_value}"

# NOTE!!! this will not be in the main  branch



token_expiry_message
{
    "success": false,
    "message": "Invalid or expired token",
    "errors": {
        "token": "Token is required"
    }
}