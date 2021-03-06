# (Inofficial) Wunderlist API Bindings
# vim: sw=2 ts=2 ai et
#
# Copyright (c) 2011 Fritz Grimpen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

module Wunderlist
  class FilterableList
    attr_accessor :tasks

    def initialize(tasks = [])
      @tasks = tasks
    end

    def today
      FilterableList.new(tasks.clone.keep_if do |t|
        t.date == Date.today && !t.done
      end)
    end

    def priority
      FilterableList.new(tasks.clone.keep_if do |t|
        t.important && !t.done
      end)
    end

    def not_priority
      FilterableList.new(tasks.clone.keep_if do |t|
        !t.important && !t.done
      end)
    end

    def done
      FilterableList.new(tasks.clone.keep_if do |t|
        t.done == true
      end)
    end

    def not_done
      FilterableList.new(tasks.clone.keep_if do |t|
        t.done != true
      end)
    end

    def overdue
      FilterableList.new(tasks.clone.keep_if do |t|
        t.date && t.date < Date.today && !t.done
      end)
    end

    def not_overdue
      FilterableList.new(tasks.clone.keep_if do |t|
        (!t.date || t.date < Date.today) && !t.done
      end)
    end
    
    def to_s
      lines = []
      lines << "[List] [Filtered] #{tasks.count != 1 ? "#{tasks.count} tasks" : "#{tasks.count} task"}"

      tasks.each do |task|
        lines << "  #{task}"
      end
      
      lines.join "\n"
    end
  end

  class List < FilterableList
    attr_accessor :id, :name, :inbox, :shared, :api

    def initialize(name = nil, inbox = nil, api = nil)
      @name = name
      @inbox = inbox
      @api = api
    end
    
    def tasks
      @tasks = @api.tasks self if @tasks == nil
      @tasks
    end

    def create_task(name, date = nil)
      Wunderlist::Task.new(name, date, self, @api).save
    end

    def save(api = nil)
      @api ||= api
      @api.save(self)
    end

    def destroy(api = nil)
      @api ||= api
      @api.destroy(self)
    end

    def flush
      @tasks = nil
    end

    def to_s
      lines = []
      lines << "[List]#{inbox ? " [INBOX]" : ""} #{name} - #{tasks.count != 1 ? (tasks.count.to_s + " tasks") : tasks.count.to_s + " task"}"

      tasks.each do |task|
        lines << "  #{task}"
      end

      lines.join "\n"
    end
  end
end
