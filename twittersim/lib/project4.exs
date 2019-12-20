defmodule Project4 do
  def main do
      [num_user, num_msg] = System.argv()
      Twitter.start()
      Twitter.simulate(String.to_integer(num_user),String.to_integer(num_msg))

  end
end

Project4.main
