def index
  GC::Tracer.start_logging(Rails.root.join("tmp/gc.txt").to_s) do
    @users = User.all.to_a
  end
end

def all_data
  @users = User.all
  calls = []
  trace = TracePoint.new(:call) do |tr|
    calls << [tr.defined_class, tr.method_id, tr.lineno]
  end
  trace.enable
  @users = User.all
  trace.disable

  pp calls.group_by(&:itself).map{|k, v | {k: v.lenght}}.sort_by{|h| -h.values.first}
end

#only 2.1
#stackprof

require 'stackprof'
def index_deb
  @user = User.all
  StackProf.run(mode: :cpu, out: 'file.tmp') do
    @users = User.all
  end
end
