json.array!(@aucrecords) do |aucrecord|
  json.extract! aucrecord, :timeproduct_id, :bidnum, :bidder, :bidtime, :status
  json.url aucrecord_url(aucrecord, format: :json)
end