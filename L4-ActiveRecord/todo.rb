require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def self.overdue
    all.filter { |todo| todo.overdue? }
  end

  def self.due_today
    all.filter { |todo| todo.due_today? }
  end

  def self.due_later
    all.filter { |todo| todo.due_later? }
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts self.overdue.map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Today\n"
    puts self.due_today.map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Later\n"
    puts self.due_later.map { |todo| todo.to_displayable_string }
    puts "\n\n"
    # todos = all.map { |todo| todo.to_displayable_string }
    # puts todos
  end

  def self.add_task(hash)
    due_date = Date.today + hash[:due_in_days]
    create!(todo_text: hash[:todo_text], due_date: due_date, completed: false)
  end

  def self.mark_as_complete!(id)
    todo = find(id)
    todo.completed = true
    todo.save
    return todo
  end
end
