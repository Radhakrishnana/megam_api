module Megam
  class API
    def get_predefs
      @options = {:path => '/predefs',:body => ""}.merge(@options)

      request(
        :expects  => 200,
        :method   => :get,
        :body     => @options[:body]
      )
    end

    def get_predef(predef_name)
      @options = {:path => "/predefs/#{predef_name}",:body => ""}.merge(@options)

      request(
        :expects  => 200,
        :method   => :get,
        :body     => @options[:body]
      )
    end

    def post_predef(new_predef)
      @options = {:path => '/predefs/content',
        :body => Megam::JSONCompat.to_json(new_predef)}.merge(@options)

      request(
        :expects  => 201,
        :method   => :post,
        :body     => @options[:body]
      )
    end

  end
end
