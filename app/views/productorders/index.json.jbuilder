json.array!(@productorders) do |productorder|
  json.extract! productorder, :timeproduct_id, :user_id, :finalprice, :tradingtime, :status, :ordernum
  json.url productorder_url(productorder, format: :json)
end