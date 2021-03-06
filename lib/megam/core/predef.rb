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
  class Predef

    def initialize
      @id = nil
      @name = nil
      @provider = nil
      @provider_role =nil
      @build_monkey=nil
      @some_msg = {}
    end

    def predef
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

    def name(arg=nil)
      if arg != nil
        @name = arg
      else
      @name
      end
    end

    def provider(arg=nil)
      if arg != nil
        @provider = arg
      else
      @provider
      end
    end
    
    def provider_role(arg=nil)
      if arg != nil
        @provider_role = arg
      else
      @provider_role
      end
    end

    def build_monkey(arg=nil)
      if arg != nil
        @build_monkey = arg
      else
      @build_monkey
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
      index_hash["name"] = name
      index_hash["provider"] = provider
      index_hash["provider_role"] = provider_role
      index_hash["build_monkey"] = build_monkey
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
        "name" => name,
        "provider" => provider,
        "provider_role" => provider_role,
        "build_monkey" => build_monkey
      }
      result
    end

    #
    def self.json_create(o)
      node = new
      node.id(o["id"]) if o.has_key?("id")
      node.name(o["name"]) if o.has_key?("name")
      node.provider(o["provider"]) if o.has_key?("provider")
      node.provider_role(o["provider_role"]) if o.has_key?("provider_role")
      node.build_monkey(o["build_monkey"]) if o.has_key?("build_monkey")
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
      @name  = o[:name] if o.has_key?(:name)
      @provider       = o[:provider] if o.has_key?(:provider)
      @provider_role  = o[:provider_role] if o.has_key?(:provider_role)
      @build_monkey   = o[:build_monkey] if o.has_key?(:build_monkey)
      self
    end

    def self.create
      predef = build
      predef.create
    end

   
    # Create the predef via the REST API
    def create(predef_input)
      megam_rest.post_predef(predef_input)
      self
    end

    # Load all predefs -
    # returns a PredefsCollection
    # don't return self. check if the Megam::PredefCollection is returned.
    def self.list
	prede = self.new()
      prede.megam_rest.get_predefs
    end

    # Show a particular predef by name,
    # Megam::Predef
    def self.show(p_name)
	prede = self.new()
      prede.megam_rest.get_predef(p_name)
    end

    def to_s
      Megam::Stuff.styled_hash(to_hash)
    #"---> Megam::Account:[error=#{error?}]\n"+
    end

  end
end
