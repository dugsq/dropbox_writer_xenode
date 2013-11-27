# Copyright Nodally Technologies Inc. 2013
# Licensed under the Open Software License version 3.0
# http://opensource.org/licenses/OSL-3.0

# 
# @version 0.1.0
#
# Dropbox Writer Xenode reads its input data context and writes the associated file to a named file in a specified Dropbox folder. 
# It leverages the "dropbox-sdk" Ruby Gem to perform the file write operation. The Xenode will read the file from a local 
# temporary folder based on the path and file information specified in the message context that it receives. If message context is 
# not found, it is expected that the file content will be available within the message data and it will be used to write to the
# named file in the specified Dropbox folder.  
#
# Config file options:
#   loop_delay:         Expected value: a float. Defines number of seconds the Xenode waits before running process(). 
#   enabled:            Expected value: true/false. Determines if the xenode process is allowed to run.
#   debug:              Expected value: true/false. Enables extra logging messages in the log file.
#   dropbox_path:       Expected value: a string. Specifies the dropbox folder where the file is expected to be written.   
#   named_file:         Expected value: a string. Specifies the file to be written.
#   access_token:       Expected value: a string. Specify the access token for your Dropbox account.
#
# Example Configuration File:
#   enabled: true
#   loop_delay: 60
#   debug: false
#   dropbox_path: "/target"
#   named_file: "hello.txt"
#   access_token: "1234567890abcdefg"
#
# Example Input:     
#   msg.context: [{:file_path=>"/temp/hello.txt",:file_name=>"hello.txt"}] 
#   msg.data:  "This string contains the actual file content to be written to Dropbox"
#
# Example Output:   The Dropbox Writer Xenode does not generate any output.  
#   

require 'dropbox_sdk'

class DropboxWriterXenode
  include XenoCore::NodeBase
  
  def startup
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
    
    begin
      
      @file_path    = @config[:dropbox_path]
      @access_token = @config[:access_token]
      @named_file   = @config[:named_file]

      if @access_token == nil
        do_debug("#{mctx} - Missing required Dropbox Access Token.")
      end
      
    rescue Exception => e
      catch_error("#{mctx} - #{e.inspect} #{e.backtrace}")
    end
  end
  
  def process_message(msg_in)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
    
    begin
      
      if msg_in
        client = DropboxClient.new(@access_token)

        if msg_in.context && msg_in.context['file_name']
          @fullpath = File.join(@file_path, msg_in.context['file_name'])
        else
          @fullpath = File.join(@file_path, @named_file)
        end

        if msg_in.context && msg_in.context['file_path']
          @localfile = File.read(msg_in.context['file_path'])
          @contents = client.put_file(@fullpath,@localfile) #file to write is read from local temp directory
        else
          @contents = client.put_file(@fullpath,msg_in.data) #file to write is passed directly within message data 
        end
        
      end
      
    rescue Exception => e
      catch_error("#{mctx} - #{e.inspect} #{e.backtrace}")
    end
  end
end