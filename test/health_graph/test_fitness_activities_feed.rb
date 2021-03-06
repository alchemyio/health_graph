require 'helper'

class TestFitnessActivitiesFeed < Minitest::Test
  context 'fitness activities' do
    setup do
      stub_request(:get, HealthGraph.endpoint + '/user')
        .with(headers: { 'Authorization' => 'Bearer ' + TEST_USER_TOKEN, 'Accept' => HealthGraph.accept_headers[:user] })
        .to_return(body: fixture('user_get.json'))

      stub_request(:get, HealthGraph.endpoint + '/fitnessActivities')
        .with(headers: { 'Authorization' => 'Bearer ' + TEST_USER_TOKEN, 'Accept' => HealthGraph.accept_headers[:fitness_activity_feed] })
        .to_return(body: fixture('fitness_activities_feed.json'))

      stub_request(:get, HealthGraph.endpoint + '/fitnessActivities?pageSize=3')
        .with(headers: { 'Authorization' => 'Bearer ' + TEST_USER_TOKEN, 'Accept' => HealthGraph.accept_headers[:fitness_activity_feed] })
        .to_return(body: fixture('fitness_activities_feed.json'))

      @user = HealthGraph::User.new(TEST_USER_TOKEN)
    end

    should 'make request to api' do
      activities = @user.fitness_activities
      assert_requested :get,  HealthGraph.endpoint + '/user', headers: { 'Authorization' => 'Bearer ' + TEST_USER_TOKEN, 'Accept' => HealthGraph.accept_headers[:user] }, times: 1
      assert_requested :get,  HealthGraph.endpoint + '/fitnessActivities', headers: { 'Authorization' => 'Bearer ' + TEST_USER_TOKEN, 'Accept' => HealthGraph.accept_headers[:fitness_activity_feed] }, times: 1
    end

    should 'make request to api with params' do
      @user.fitness_activities(pageSize: 3)
      assert_requested :get,  HealthGraph.endpoint + '/fitnessActivities?pageSize=3', headers: { 'Authorization' => 'Bearer ' + TEST_USER_TOKEN, 'Accept' => HealthGraph.accept_headers[:fitness_activity_feed] }, times: 1
    end

    should 'get body' do
      expected = { 'items'=>
        [{ 'duration'=>7920,
          'total_distance'=>62764.416,
          'start_time'=>'Thu, 15 Sep 2011 13:28:59',
          'type'=>'Cycling',
          'uri'=>'/fitnessActivities/52367938' },
         { 'duration'=>1080,
          'total_distance'=>2574.9504,
          'start_time'=>'Thu, 15 Sep 2011 08:00:00',
          'type'=>'Walking',
          'uri'=>'/fitnessActivities/52367984' },
         { 'duration'=>2880,
          'total_distance'=>7402.9824,
          'start_time'=>'Wed, 14 Sep 2011 20:00:00',
          'type'=>'Running',
          'uri'=>'/fitnessActivities/52368041' },
         { 'duration'=>3060,
          'total_distance'=>7724.8512,
          'start_time'=>'Tue, 13 Sep 2011 20:00:00',
          'type'=>'Running',
          'uri'=>'/fitnessActivities/52368120' },
         { 'duration'=>4500,
          'total_distance'=>5632.704,
          'start_time'=>'Tue, 13 Sep 2011 08:00:00',
          'type'=>'Running',
          'uri'=>'/fitnessActivities/52126193' }],
       'size'=>5 }

      assert_equal expected, @user.fitness_activities.body
    end

    context 'item' do
      should 'get items' do
        expected = [{ 'duration'=>7920,
          'total_distance'=>62764.416,
          'start_time'=>'Thu, 15 Sep 2011 13:28:59',
          'type'=>'Cycling',
          'uri'=>'/fitnessActivities/52367938' },
         { 'duration'=>1080,
          'total_distance'=>2574.9504,
          'start_time'=>'Thu, 15 Sep 2011 08:00:00',
          'type'=>'Walking',
          'uri'=>'/fitnessActivities/52367984' },
         { 'duration'=>2880,
          'total_distance'=>7402.9824,
          'start_time'=>'Wed, 14 Sep 2011 20:00:00',
          'type'=>'Running',
          'uri'=>'/fitnessActivities/52368041' },
         { 'duration'=>3060,
          'total_distance'=>7724.8512,
          'start_time'=>'Tue, 13 Sep 2011 20:00:00',
          'type'=>'Running',
          'uri'=>'/fitnessActivities/52368120' },
         { 'duration'=>4500,
          'total_distance'=>5632.704,
          'start_time'=>'Tue, 13 Sep 2011 08:00:00',
          'type'=>'Running',
          'uri'=>'/fitnessActivities/52126193' }]

        assert_equal expected, @user.fitness_activities.items
        assert_equal 5, @user.fitness_activities.items.size
      end

      should 'get start time' do
        assert_equal 'Thu, 15 Sep 2011 13:28:59', @user.fitness_activities.items[0].start_time
      end

      should 'get duration' do
        assert_equal 7920, @user.fitness_activities.items[0].duration
      end

      should 'get total distance' do
        assert_equal 62764.416, @user.fitness_activities.items[0].total_distance
      end

      should 'get type' do
        assert(!@user.fitness_activities.items[0].type.nil?)
      end

      should 'get uri' do
        assert(!@user.fitness_activities.items[0].uri.nil?)
      end
    end
  end
end
