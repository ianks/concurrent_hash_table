describe ConcurrentHashTable::ConcurrentHashTable do
  let(:data) do
    {
      'current_user_url' => 'https://api.legithub.com/user',
      'authorizations_url' => 'https://api.legithub.com/authorizations',
      'emails_url' => 'https://api.legithub.com/user/emails',
      'emojis_url' => 'https://api.legithub.com/emojis',
      'events_url' => 'https://api.legithub.com/events',
      'feeds_url' => 'https://api.legithub.com/feeds',
      'following_url' => 'https://api.legithub.com/user/following{/target}',
      'gists_url' => 'https://api.legithub.com/gists{/gist_id}',
      'hub_url' => 'https://api.legithub.com/hub',
      'issues_url' => 'https://api.legithub.com/issues',
      'keys_url' => 'https://api.legithub.com/user/keys',
      'notifications_url' => 'https://api.legithub.com/notifications',
      'organization_url' => 'https://api.legithub.com/orgs/{org}',
      'public_gists_url' => 'https://api.legithub.com/gists/public',
      'rate_limit_url' => 'https://api.legithub.com/rate_limit',
      'repository_url' => 'https://api.legithub.com/repos/{owner}/{repo}',
      'starred_url' => 'https://api.legithub.com/user/starred{/owner}{/repo}',
      'starred_gists_url' => 'https://api.legithub.com/gists/starred',
      'team_url' => 'https://api.legithub.com/teams',
      'user_url' => 'https://api.legithub.com/users/{user}',
      'user_organizations_url' => 'https://api.legithub.com/user/orgs'
    }
  end

  describe '[]=' do
    context 'single-threaded' do
      it 'can be pushed to' do
        hash = ConcurrentHashTable::ConcurrentHashTable.new 20
        data.each { |key, val| hash[key] = val }
        data.each { |key, val| expect(hash[key]).to eq val }
      end
    end

    context 'multi-threaded' do
      it 'can be pushed to' do
        hash = ConcurrentHashTable::ConcurrentHashTable.new 20
        threads = []

        32.times do
          threads << Thread.new do
            data.each { |key, val| hash[key] = val }
            data.each { |key, val| expect(hash[key]).to eq val }
          end
        end

        threads.each(&:join)
      end
    end
  end

  describe 'stress test' do
    it 'survives ridiculous threaded conditions' do
      hash = ConcurrentHashTable::ConcurrentHashTable.new 20
      threads = []

      32.times do
        threads << Thread.new do
          expect do
            200.times do
              key = SecureRandom.hex
              val = key
              hash[key] = val

              expect(hash[key]).to eq val
            end
          end.to_not raise_error
        end
      end

      threads.each { |t| t.abort_on_exception = true }
      threads.each(&:join)
    end

    it 'survives a ton of contention on one bin' do
      threads = []
      hash = ConcurrentHashTable::ConcurrentHashTable.new 20

      key = SecureRandom.hex
      val = key

      128.times do
        threads << Thread.new do
          expect do
            800.times do
              hash[key] = val

              expect(hash[key]).to eq val
            end
          end.to_not raise_error
        end
      end

      threads.each { |t| t.abort_on_exception = true }
      threads.each(&:join)
    end
  end
end
