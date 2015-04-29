require 'httparty'
module ClusterPoint
  RAILS_ENV   = -> { (Rails.env if defined?(Rails.env)) || ENV["RAILS_ENV"] || ENV["RACK_ENV"] }
  DEFAULT_ENV = -> { RAILS_ENV.call || "default_env" }

  class ClusterPointAdapter
    include HTTParty
    include ClusterPoint::Configuration

    def initialize
      load_config
      @auth = {:username => @config["username"], :password => @config["password"]}
    end

    def update(document)
      options = { body: document.as_json,
                  basic_auth: @auth,
                  headers: { 'Content-Type' => 'application/json, charset=utf-8' }}
      resp = self.class.put("/#{document.id}.json", options)
      resp.body
    end

    def insert(document)
      options = { body: document.as_json,
                  basic_auth: @auth,
                  headers: { 'Content-Type' => 'application/json, charset=utf-8' }}
      resp = self.class.put("/.json", options)
      resp.body
    end

    def delete(id)
      options = { basic_auth: @auth,
                  headers: { 'Content-Type' => 'application/json, charset=utf-8' } }
      resp = self.class.delete('/' + id + '.json', options)
      if resp.code == 200
        resp.body
      else
        raise "Error while getting data: " + resp.response.to_s
      end
    end

    def query(text, docs = 10, offset=0)
      options = { body: [{ query: text, 
                           docs: docs, 
                           offset: offset
                        }].to_json,
                  basic_auth: @auth,
                  headers: { 'Content-Type' => 'application/json, charset=utf-8' } }
      resp = self.class.post('/_search.json', options)
      resp.body
    end

    def get(id)
      options = { basic_auth: @auth,
                  headers: { 'Content-Type' => 'application/json, charset=utf-8' } }
      resp = self.class.get('/' + id + '.json', options)
      if resp.code == 200
        resp.body
      else
        raise "Error while getting data: " + resp.response.to_s
      end
    end

    def where(conditions={}, ordering={string: {id: :ascending}}, docs=20, offset=0)
      query_xml = conditions.to_xml(skip_instruct: true, skip_types: true, indent: 1)
      ordering_xml = ordering.to_xml(skip_instruct: true, skip_types: true, indent: 1)
      options = { body: [{ query: query_xml.lines.to_a[1..-2].join,
                           ordering: ordering_xml.lines.to_a[1..-2].join,
                           docs: docs,
                           offset: offset
                        }].to_json,
                  basic_auth: @auth,
                  headers: { 'Content-Type' => 'application/json, charset=utf-8' } }
      resp = self.class.post('/_search.json', options)
      resp.body
    end

  end

end