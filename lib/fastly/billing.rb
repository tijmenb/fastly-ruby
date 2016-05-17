class Fastly::Customer
  include Fastly::Model

  identity :id, alias: "invoice_id"

  attribute :bandwidth, squash: "total"                        # The total amount of bandwidth used this month in Gb.
  attribute :bandwidth_cost, squash: "total"                   # The cost of the bandwidth used this month in USD.
  attribute :cost, squash: ["total", "extras"]                 # The final amount to be paid.
  attribute :cost_before_discount, squash: ["total", "extras"] # Total incurred cost plus extras cost.
  attribute :discount, squash: ["total", "extras"]             # Calculated discount rate.
  attribute :end_time, type: :time                             # The end date of this invoice.
  attribute :extras, squash: "total"                           # A list of any extras for this invoice.
  attribute :extras_cost, squash: ["total", "extras"]          # Total cost of all extras.
  attribute :incurred_cost, squash: "total"                    # The total cost of bandwidth and requests used this month.
  attribute :name, squash: ["total", "extras"]                 # The name of this extra cost
  attribute :overage, squash: "total"                          # How much over the plan minimum has been incurred.
  attribute :plan_code, squash: "total"                        # The short code the plan this invoice was generated under.
  attribute :plan_minimum, squash: "total"                     # The minimum cost of this plan.
  attribute :plan_name, squash: "total"                        # The name of the plan this invoice was generated under.
  attribute :recurring, squash: ["total", "extras"]            # Recurring monthly cost in USD (not present if $0.0).
  attribute :requests, squash: "total"                         # The total number of requests used this month.
  attribute :requests_cost, squash: "total"                    # The cost of the requests used this month.
  attribute :sent_at, squash: "status"                         # When the invoice was sent out (if Outstanding or Paid)
  attribute :setup, squash: ["total", "extras"]                # Initital set up cost in USD (not present if $0.0 or this is not the month the extra was added).
  attribute :start_time, type: :time                           # The start date of this invoice.
  attribute :status, squash: "status"                          # What the current status of this invoice can be. One of Pending (being generated), Outstanding (unpaid), Paid (paid), Month to date (the current month)
  attribute :terms, squash: ["total", "extras"]                # Payment terms. Almost always Net15.

end
