class CartController < ApplicationController
  def show
  	range = [*'0'..'9',*'A'..'Z',*'a'..'z']
    @cart_no = Array.new(9){ range.sample }.join
  	payload = "merchant_key|#{@cart_no}|2.0|ProductInfo|first_name|youremail@domain.com|merchant_salt"
    @hash_val = Digest::SHA512.hexdigest( payload )
  end

  def payu_callback

  	notification = PayuIndia::Notification.new(request.query_string, options = {:key => 'merchant_key', :salt => 'merchant_salt', :params => params})
    #@cart = Cart.find(notification.invoice) # notification.invoice is order id/cart id which you have submited from payment direction page.
    if notification.acknowledge
      begin
        if notification.complete?
          #order = Order.create(total_amount: notification.gross, paid_amount: notification.gross,  order_no: notification.invoice, payment_mode: params[:mode], order_date: params[:addedon])
          redirect_to root_path
        else
          @cart.status = "failed"
          render :text => "Order Failed! #{notification.message}"
        end
      ensure
        @cart.save
      end
    end

  end
end
