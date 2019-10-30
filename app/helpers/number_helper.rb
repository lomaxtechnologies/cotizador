module NumberHelper
  def number_to_currency_gt(number)
    number_to_currency(number, :unit => " ", :separator => ".", :delimiter => ",")
  end
end
