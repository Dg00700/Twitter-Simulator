defmodule Utility do
  def test_registration(user_id,user_name,password) do
    databaseValue = Server.retreive_d(:user_details, user_id)
    if ([user_id,user_name,password] == databaseValue) do
        IO.puts "Success"
        true
    else

        false
    end
end

def test_login(user_id) do
    if (Server.retreive_d(:active_users, user_id) == true) do
        IO.puts "Success"
        true
    else

        false
    end
end

def test_follower(user_id,follower_id) do
    databaseValue = Server.retreive_d(:follower_list, user_id)
    if (Enum.member?(databaseValue, follower_id)) do
        IO.puts "Success "
        true
    else

        false
    end
end

def test_tweet(user_id,message) do
    tweet_id = Server.retreive_d(:user_tweets, user_id) |> Enum.find(fn {key, val} -> val == message end) |> elem(0)
    followers_list = Server.retreive_d(:follower_list, user_id)
    receivedByAll = Enum.reduce(followers_list,[], fn(follower,received)->
        if(Enum.member?(Server.retreive_d(:newsfeed, follower), [user_id,tweet_id])) do
            received = received ++ [true]
        else
            received = received ++ [false]
        end
    end)
    if(Enum.member?(receivedByAll, false)) do
        IO.puts "Success"
        false
    else
        IO.puts "Success"
        true
    end
end

def test_retweet(user_id,message) do
    tweet_id = Server.retreive_d(:user_tweets, user_id) |> Enum.find(fn {key, val} -> val == message end) |> elem(0)
    followers_list = Server.retreive_d(:follower_list, user_id)
    Enum.each(followers_list, fn(user_id)->
        message_list = :ets.lookup(:newsfeed,user_id)

    end)
    receivedByAll = Enum.reduce(followers_list,[], fn(follower,received)->
        if(Enum.member?(Server.retreive_d(:newsfeed, follower), [user_id,tweet_id])) do
            received = received ++ [true]
        else
            received = received ++ [false]
        end
    end)
    if(Enum.member?(receivedByAll, false)) do
        IO.puts "Tweet \"#{message}\" not received by all the followers"
        false
    else
        IO.puts "Tweet \"#{message}\" received by all the followers"
        true
    end
end

def test_mention(user_id,message,mentioned_id) do
    tweet_id = Server.retreive_d(:user_tweets, user_id) |> Enum.find(fn {_key, val} -> val == message end) |> elem(0)
    if(Enum.member?(Server.retreive_d(:newsfeed, mentioned_id), [user_id,tweet_id])) do
        IO.puts "Tweet \"#{message}\" received by mentioned user #{mentioned_id}"
        true
    else
        IO.puts "Tweet \"#{message}\" not received by mentioned user #{mentioned_id}"
        false
    end
end

def test_hashtag(user_id,message,hashtag) do
    tweet_id = Server.retreive_d(:user_tweets, user_id) |> Enum.find(fn {_key, val} -> val == message end) |> elem(0)
    if(Enum.member?(Server.retreive_d(:hashtags, hashtag), [user_id,tweet_id])) do
        IO.puts "Success"
        true
    else
        IO.puts "Failed "
        false
    end
end

def test_tweet(user_id,sender_id,message) do
    tweet_id = Server.retreive_d(:user_tweets, sender_id) |> Enum.find(fn {_key, val} -> val == message end) |> elem(0)
    if(Enum.member?(Server.retreive_d(:newsfeed, user_id), [sender_id,tweet_id])) do

        true
    else

        false
    end
end

def check_hashtag(hashtag) do
    hashtag_list = (Server.retreive_d(:hashtags, hashtag))
    if(hashtag_list!=[]) do

        true
    else

        false
    end
end

def test_mentions(mentions) do
    mentions_list = (Server.retreive_d(:mentions, mentions))
    if(mentions_list!=[]) do

        true
    else

        false
    end
end



def check_test_register(user_id) do
  data=:ets.lookup(:register,user_id)
  IO.inspect ("Data #{data}")
  if(data==[]) do
      0
  end
 end
 def check_test_follower(user_id,x) do
  data=:ets.lookup(:followers,x)
  IO.inspect data
  Enum.member?(data,{x,user_id})

  end

  def check_test_followee(x,user) do
      data=:ets.lookup(:followee,user)
      IO.inspect data
      Enum.member?(data,{x,user})

  end


def get_followers_list(user_id) do
    databaseValue = Server.retreive_d(:follower_list, user_id)
end

end

