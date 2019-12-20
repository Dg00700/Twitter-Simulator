defmodule TwittersimTest do
  use ExUnit.Case
  doctest Twittersim
  @user_lists Enum.to_list(1..10) |> Enum.map(fn(user)-> "User-"<>Integer.to_string(user) end)
  setup_all do
    IO.puts("Creating the Network")
    Twitter.start()
    Twitter.simulate(10, 3)
    :timer.sleep(1000)
    :ok
  end


  test "Register new user " do
    IO.puts "Register new user"
    {:ok, _pid} = Client.start("User-11")
    Client.registration("User-11","User-11","User-11")
   # Process.sleep(1000)
    assert Utility.test_registration("User-11","User-11","User-11") == true
    IO.puts "Test1 Passed"
  end


  test "Login correctly" do
    IO.puts "Login correctly"
    Client.logout("User-10")
    Client.login("User-10", "User-10")
   # Process.sleep(1000)
    assert Utility.test_login("User-10") == true
    IO.puts "Test2 Passed"
  end

  test "Followers Check" do
    IO.puts "Followers check"
    #Creating a new User so that a new follower gets added to the new user

    follower_id = Enum.random(@user_lists)
    Client.follower("User-22","User-22","User-22",follower_id)
    Process.sleep(1000)
    assert Utility.test_follower("User-22",follower_id) == true
    IO.puts "Test5 Passed"  end

  test "Send Tweets" do
    Client.send_tweets("User-10","Hello This is a new message")
    Process.sleep(1000)
    assert Utility.test_tweet("User-10","Hello This is a new message") == true
    IO.puts "Test6 Passed"
  end

  test "Received Tweets" do
    IO.puts "Received Tweets-"
    message = "This is a message that mentioned @"<>"User-4"
    Client.send_tweets("User-10",message)
    Process.sleep(1000)
    assert Utility.test_tweet("User-10",message) and Utility.test_mention("User-10",message,"User-4") == true
    IO.puts "Test7 Passed"
  end



  test "Testing Login with incorect credential" do
    IO.puts "Login incorrectly"

    Client.logout("User-10")
    Client.login("User-10", "Hello")
    Process.sleep(1000)
    assert Utility.test_login("User-10") == false
    IO.puts "Test3 Passed"
  end

  test "Testing Logout" do
    IO.puts "Wrong Login"
    Client.logout("User-3")
    Process.sleep(1000)
    assert Utility.test_login("User-3") == false
    Client.login("User-3","User-3")
    IO.puts "Test4 Passed"
  end


  test "Hashtag rightly stored" do
    message = "This is a message with hashtag "<>"#BoilTest"
    Client.send_tweets("User-10",message)
    Process.sleep(1000)
    assert Utility.test_hashtag("User-10",message,"#BoilTest") == true
    IO.puts "Test8 Passed"
  end


  test "Retweet done" do
    IO.puts "Retweet Done"
    message_retweeted = Client.retweets("User-7")
    IO.inspect message_retweeted, label: "Message Retweeted"
    Process.sleep(1000)
    assert Utility.test_tweet("User-7",message_retweeted) == true
    IO.puts "Test9 Passed"
  end




  test "Querying by Hashtags" do
    IO.puts "\nQuerying by Hashtags"
    message = "This is a message that has hashtag "<>"#GoGators"
    Client.send_tweets("User-10",message)
    #Twitter.print_tweet_list(@user_lists)
    assert Utility.check_hashtag("GoGators") == true
    IO.puts "Test10 Passed"
  end

  test "Querying by Mentions" do
    IO.puts " Querying by Mentions"
    message = "This is a message that has mentioned @"<>"User-3"
    Client.send_tweets("User-10",message)
    #Twitter.print_tweet_list(@user_lists)
    assert Utility.test_mentions("User-3") == true
    IO.puts "Test11 Passed"
  end


  test "greets the world" do
    assert Twittersim.hello() == :world
  end
end
