class MapController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    solr_base = "#{ENV['SOLR_SERVER'] || 'http://localhost'}:#{ENV['SOLR_PORT'] || 8983}#{ENV['SOLR_ROOT']}"
    solr_query_url = solr_base + '?q=pl_wgs84_pos_lat:*&fl=europeana_id%2Cpl_wgs84_pos_long%2C+pl_wgs84_pos_lat&wt=json&indent=true&rows=1000'
    search = JSON.load(open(solr_query_url))['response']
    # Europeana::API.record.search(query: 'pl_wgs84_pos_lat:*', profile: 'rich', rows: 1000)

    @markers = extract_markers(search['docs'])
  end

  def extract_markers(items)
    items.map do |item|
      if [item['pl_wgs84_pos_lat'].is_a?(Array) && item['pl_wgs84_pos_long']].is_a?(Array)
        { latlng: "[#{item['pl_wgs84_pos_lat'][0]}, #{item['pl_wgs84_pos_long'][0]}]", id: item['europeana_id'] }
      else
        { latlng: "[#{item['pl_wgs84_pos_lat']}, #{item['pl_wgs84_pos_long']}]", id: item['europeana_id'] }
      end
    end
  end
end
