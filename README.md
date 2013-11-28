Dropbox Writer Xenode
=====================

**Dropbox Writer Xenode** reads its input data context and writes the associated file to a named file in a specified Dropbox folder. It leverages the "dropbox-sdk" RubyGem to perform the file write operation. The Xenode will read the file from a local temporary folder based on the path and file information specified in the message context that it receives. If message context is not found, it is expected that the file content will be available within the message data and it will be used to write to the named file in the specified Dropbox folder.  

###Configuration file options:
* loop_delay: defines number of seconds the Xenode waits before running the Xenode process. Expects a float. 
* enabled: determines if this Xenode process is allowed to run. Expects true/false.
* debug: enables extra debug messages in the log file. Expects true/false.
* dropbox_path: specifies the dropbox folder where the file is expected to be written. Expects a string.   
* named_file: specifies the file to be written. Expects a string.
* access_token: specify the application access token for your Dropbox account. Expects a string.

###Example Configuration File:
* enabled: true
* loop_delay: 60
* debug: false
* dropbox_path: "/target"
* named_file: "hello.txt"
* access_token: "1234567890abcdefg"

###Example Input:     
* msg.context: [{:file_path=>"/temp/hello.txt",:file_name=>"hello.txt"}] 
* msg.data:  "This string contains the actual file content to be written to Dropbox"

###Example Output:   
* The Dropbox Writer Xenode does not generate any output.
