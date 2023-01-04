class RaceUpdater < ApplicationService
  def initialize(race, status, random_flag = false)
    @race = race
    @status = status
    @random_flag = random_flag
  end

  def call
    if @status != :FINISHED
      return {
        result: false,
        message: 'Invalid race status update'
      }
    end

    if @random_flag && !update_runs_random
      return {
        result: false,
        message: 'Could not update runs with random'
      }
    end

    @race.status = @status
    @race.winner = get_winner
    save_race = @race.save

    {
      result: save_race,
      message: @race.errors.messages.first
    }
  end

  private
  def generate_random_run_results(runners_count, race_duration)
    Array.new(runners_count) { rand((race_duration / 2)..(race_duration + 0.75)) }
  end

  def generate_run_update_hash(registered_runs, random_runs_list)
    formatted_updates = []

    sorted_runs_list = random_runs_list.sort

    registered_runs.each_with_index do |run, index|
      run_duration = random_runs_list[index]
      run_status = if run_duration <= @race.duration
                     :FINISHED
                   else
                     :UNFINISHED
                   end
      run_place = sorted_runs_list.find_index(run_duration) + 1

      formatted_updates << { id: run.id, duration: run_duration, status: run_status, place: run_place }
    end

    formatted_updates.index_by { |run| run[:id] }
  end

  def update_runs_random
    registered_runs = @race.registered_runs

    random_runs_list = generate_random_run_results(registered_runs.count, @race.duration)
    run_update_hash = generate_run_update_hash(registered_runs, random_runs_list)

    Run.update(run_update_hash.keys, run_update_hash.values)
  end

  def get_winner
    @race.registered_runs.where(place: 1).first.id
  end
end
