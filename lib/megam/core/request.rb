# Copyright:: Copyright (c) 2012, 2013 Megam Systems
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module Megam
  class Request
    def initialize
      @id = nil
      @node_id = nil
      @node_name = nil
      @command =nil
      @some_msg = {}
    end

    def request
      self
    end

    def megam_rest
      options = { :email => Megam::Config[:email], :api_key => Megam::Config[:api_key]}
      Megam::API.new(options)
    end

    def id(arg=nil)
      if arg != nil
        @id = arg
      else
      @id
      end
    end

    def node_id(arg=nil)
      if arg != nil
        @node_id = arg
      else
      @node_id
      end
    end

    def node_name(arg=nil)
      if arg != nil
        @node_name = arg
      else
      @node_name
      end
    end

    def command(arg=nil)
      if arg != nil
        @command = arg
      else
      @command
      end
    end

    def some_msg(arg=nil)
      if arg != nil
        @some_msg = arg
      else
      @some_msg
      end
    end

    def error?
      crocked  = true if (some_msg.has_key?(:msg_type) && some_msg[:msg_type] == "error")
    end

    # Transform the ruby obj ->  to a Hash
    def to_hash
      index_hash = Hash.new
      index_hash["json_claz"] = self.class.name
      index_hash["id"] = id
      index_hash["node_id"] = node_id
      index_hash["node_name"] = node_name
      index_hash["command"] = command
      index_hash
    end

    # Serialize this object as a hash: called from JsonCompat.
    # Verify if this called from JsonCompat during testing.
    def to_json(*a)
      for_json.to_json(*a)
    end

    def for_json
      result = {
        "id" => id,
        "node_id" => node_id,
        "node_name" => node_name,
        "command" => command
      }
      result
    end

    #
    def self.json_create(o)
      node = new
      node.id(o["id"]) if o.has_key?("id")
      node.node_id(o["node_id"]) if o.has_key?("node_id")
      node.node_name(o["node_name"]) if o.has_key?("node_name")
      node.command(o["command"]) if o.has_key?("command")
      #success or error
      node.some_msg[:code] = o["code"] if o.has_key?("code")
      node.some_msg[:msg_type] = o["msg_type"] if o.has_key?("msg_type")
      node.some_msg[:msg]= o["msg"] if o.has_key?("msg")
      node.some_msg[:links] = o["links"] if o.has_key?("links")
      node
    end

    def self.from_hash(o)
      node = self.new()
      node.from_hash(o)
      node
    end

    def from_hash(o)
      @id = o[:id] if o.has_key?(:id)
      @node_id  = o[:node_id] if o.has_key?(:node_id)
      @node_name       = o[:node_name] if o.has_key?(:node_name)
      @command  = o[:command] if o.has_key?(:command)
      self
    end

    
     def self.list
      prede = self.new()
      prede.megam_rest.get_requests
    end

     def self.show(n_name)
      prede = self.new()
      prede.megam_rest.get_request(n_name)
    end

    def to_s
      Megam::Stuff.styled_hash(to_hash)
    #"---> Megam::Account:[error=#{error?}]\n"+
    end

  end
end
