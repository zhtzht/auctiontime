json.array!(@timeproducts) do |timeproduct|
  json.extract! timeproduct, :name, :lowprice, :merprice, :starttime, :continuedtime, :status
  json.url timeproduct_url(timeproduct, format: :json)
end