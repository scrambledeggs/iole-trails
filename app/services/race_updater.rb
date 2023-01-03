class RaceUpdater < ApplicationService
  def initialize(race, status)
    @race = race
    @status = status
  end

  def call
    return false if @status != :FINISHED

    formatted_updates = []
    first_placer = 0
    registered_runs = @race.registered_runs

    rand_run_duration = registered_runs.length.times.map {
      rand((@race.duration / 2)..(@race.duration + 1.5))
    }
    sorted_duration = rand_run_duration.sort

    registered_runs.each_with_index do |run, index|
      run_duration = rand_run_duration[index]
      run_status = if run_duration <= @race.duration
                     :FINISHED
                   else
                     :UNFINISHED
                   end
      run_place = sorted_duration.find_index(run_duration) + 1

      first_placer = run.id if run_place == 1

      formatted_updates << { id: run.id, duration: run_duration, status: run_status, place: run_place }
    end

    formatted_updates = formatted_updates.index_by { |run| run[:id] }

    return false if !Run.update(formatted_updates.keys, formatted_updates.values)

    @race.status = @status
    @race.winner = first_placer
    @race.save
  end
end
