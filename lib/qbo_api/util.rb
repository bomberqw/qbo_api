class QboApi
  module Util
    def cdc_time(time)
      if time.is_a?(String)
        time
      else
        time.iso8601
      end
    end

    def uuid
      SecureRandom.uuid
    end

    def add_request_id_to(path)
      if QboApi.request_id
        add_params_to_path(path: path, params: { "requestid" => uuid })
      else
        path
      end
    end

    def add_params_to_path(path:, params:)
      uri = URI.parse(path)
      params.each do |p|
        new_query_ar = URI.decode_www_form(uri.query || '') << p.to_a
        uri.query = URI.encode_www_form(new_query_ar)
      end
      uri.to_s
    end

    def join_or_start_where_clause!(select:)
      if select.match(/where/i)
        str = ' AND '
      else
        str = ' WHERE '
      end
      str
    end

    def build_all_query(entity, select: nil, inactive: false)
      select ||= "SELECT * FROM #{singular(entity)}"
      select += join_or_start_where_clause!(select: select) + 'Active IN ( true, false )' if inactive
      select
    end

  end
end

