defmodule Twitter do

  def start() do
      GenServer.start_link(__MODULE__, [], name: :twitter)
  end

  def init(state) do
      Registry.start_link(keys: :unique, name: :registry)
      Server.start()
      {:ok, state}
  end

  def simulate(num_user, num_msg) do
      users_list = Enum.to_list(1..num_user) |> Enum.map(fn(user)-> "User-"<>Integer.to_string(user) end)
      Enum.each(users_list, fn(user_id) ->
          {:ok, pid} = Client.start(user_id)
          GenServer.call(pid, {:create_account, user_id,user_id,user_id})
      end)

      create_follower_list(num_user,users_list)
      Enum.each(1..num_msg, fn(count)->
          start_sending_message(users_list,num_user)
      end)
    Process.sleep(1000)
      users_list
  end

  def create_follower_list(num_user,users_list) do
      temp_users_list = users_list
      percent_of_category1_user = floor((num_user/100)*80)
      percent_of_category2_user = floor((num_user/100)*20)
      category1_user_list = Enum.take_random(temp_users_list,percent_of_category1_user)
      temp_users_list = temp_users_list -- category1_user_list
      category2_user_list = Enum.take_random(temp_users_list,percent_of_category2_user)

      dist=zipf(num_user)
      v = 0.9*num_user |> round
      v = Enum.random(v..num_user)
      total_followers = v/dist[1] |> round
      total_followers1=(total_followers/4) |> round
      total_followers2=((total_followers/4) |> round)+1
      generate_follower_list(users_list, category1_user_list,total_followers1)
      generate_follower_list(users_list, category2_user_list,total_followers2)

  end


  def zipf(n, alpha \\ 1) do
      c = 1/Enum.reduce(1..n, 0, fn (x, acc) ->
          _acc = acc + 1/:math.pow(x,alpha) end)
      Enum.reduce(1..n, %{}, fn (x, acc) ->
          _acc = Map.put(acc, x, c/:math.pow(x,alpha)) end)
end

def generate_follower_list(users_list, category_user_list, followers_number) do
  Enum.each(category_user_list, fn(user_id) ->
      #no_of_followers = Enum.random(followers_number)
      followers_list = Enum.take_random(users_list--[user_id], followers_number)
      Enum.each(followers_list, fn(follower_id) ->
          GenServer.cast(get_pid(user_id),{:follow, follower_id})
      end)
  end)
end


  def start_sending_message(users_list,num_user) do
      message_list= ["booyaaaaaaaaa.", "Merry christmas", "Where do you wanno go?" ,"Scooby Dooby doo.","Imma so hungry.","How you doing?","Welcome to the jungle.","Take me home to the paradise city."]
      hashtag_list=["#husky","#boo","#elixi","#final","#pizza","#UF","#GoGators","#Nirvana","#GunnRoses","#Happy"]
      Enum.each(users_list, fn(user_id)->
          message = Enum.random(message_list)
                  |> String.replace("#",Enum.random(hashtag_list))
                  |> String.replace("@","@"<>Enum.random(users_list--[user_id]))
          GenServer.cast(get_pid(user_id),{:tweet_msg,message})
      end)
  end


  def get_pid(user_handle) do
      case Registry.lookup(:registry, user_handle) do
          [{pid, _}] -> pid
          [] -> nil
      end
  end

 end
