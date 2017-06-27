class MapController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    search = Europeana::API.record.search(query: 'pl_wgs84_pos_lat:*', profile: 'rich', rows: 1000)
    @markers = extract_markers(search[:items])
  end

  def extract_markers(items)
    items.map do |item|
      if [item['edmPlaceLatitude'].is_a?(Array) && item['edmPlaceLongitude']].is_a?(Array)
        { latlng: [item['edmPlaceLatitude'][0], item['edmPlaceLongitude'][0]] }
      else
        { latlng: [item['edmPlaceLatitude'], item['edmPlaceLongitude']] }
      end
    end
  end
end
