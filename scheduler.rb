#### Variable Formats:

#emp = [{name: 'Jack', role: 'cook', avail: [[[start, end],[,]..], [...]}, ...]
#shifts = [[{time: [], cook: 2, ...}, #shift2,...], [...], #tue,...]
#schedule = [[[0, 1,..#empindex for shift1], [#shift2]..], [#mon..]]
############################################################

MUTATE_RATE = 0.01
CROSS_RATE = 0.7
GENERATIONS = 1000
POPSIZE = 50
class Schedule
  attr_accessor :avail_table #testing only, delete me
  attr_accessor :schedule
  def initialize(emp, shifts)
    @emp = emp
    @shifts = shifts
    @avail_table = Array.new(7) {Array.new}
    @schedule = Array.new(7) {Array.new}
  end

  class Chrom
    attr_accessor :chromstr
    attr_accessor :fitness
    def initialize(chromstr, fitness)
      @chromstr = chromstr
      @fitness = fitness
    end
  end

  def init
    @avail_table.each_with_index do |day, d|
      @shifts[d].each_with_index do |shift, s|
        shiftarray = []
        shifttime = shift[:time]
        @emp.each_with_index do |emp, e|
          emp[:avail][d].each do |tarray|
            if shift[emp[:role]].to_i > 0 && tarray[0] <= shifttime[0] && tarray[1] >= shifttime[1]
              shiftarray << e
            end
          end
        end
        day << shiftarray
        @schedule[d] << []
      end
    end
    calcChromLen
  end

  def calcChromLen
    @chromLen = @avail_table.flatten.length
  end

  def calcFitness(chromstr)
    loc = 0
    penalty = 0;
    @avail_table.each_with_index do |day, d|
      day.each_with_index do |shift, s|
        role_count = {}
        shift.each do |e|
          if chromstr[loc] == '1'
            role_count[@emp[e][:role]] ||= 0;
            role_count[@emp[e][:role]] += 1;
          end
          loc += 1
        end
        @shifts[d][s].keys.each do |role|
          if role != :time
            if role_count[role].nil?
              penalty += 100
            elsif role_count[role] < @shifts[d][s][role]
              penalty += 50
            elsif role_count[role] > @shifts[d][s][role]
              return 0
            end
          end
        end
      end
    end
    return 1/(1 + penalty)
  end

  def decode(chrom)
    loc = 0
    @avail_table.each_with_index do |day, d|
      day.each_with_index do |shift, s|
        shift.each do |emp|
          if chrom[loc] == '1'
            @schedule[d][s] << emp
          end
          loc += 1
        end
      end
    end
  end

  def select(totalf)
    loc = rand(0.0..totalf)
    currSum = 0.0
    for i in 0...POPSIZE
      currSum += @population[i].fitness
      if currSum >= loc
        return @population[i].chromstr
      end
    end
  end

  def mutate(chromstr)
    for i in 0...@chromLen
      if rand(0.0..1.0) < MUTATE_RATE
        if chromstr[i] == '1'
          chromstr[i] = '0'
        else
          chromstr[i] = '1'
        end
      end
    end
  end

  def crossover(chromstr1, chromstr2)
    if rand(0.0..1.0) < CROSS_RATE
      crosspoint = rand(0...@chromLen)
      temp = chromstr1[0...crosspoint] + chromstr2[crosspoint..-1]
      chromstr2 = chromstr2[0...crosspoint] + chromstr1[crosspoint..-1]
      chromstr1 = temp
    end
  end

  def genRandChrom
    chromstr = ''
    @chromLen.times do
      if rand(0..1) > 0.5
        chromstr += '1'
      else
        chromstr += '0'
      end
    end
    return chromstr
  end

  def genPopulation
    @population = []
    POPSIZE.times do
      @population << Chrom.new(genRandChrom, nil)
    end
  end

  def evalAllFitness
    totalFit = 0.0
    @population.each do |c|
      c.fitness = calcFitness(c.chromstr)
      totalFit += c.fitness
    end
    return totalFit
  end

  def findFittestChrom
    maxFitness = -99999
    mfchrom = ''
    @population.each do |c, i|
      if c.fitness > maxFitness
        maxFitness = c.fitness
        mfchrom = c.chromstr
      end
    end
    return mfchrom
  end

  def evolution
    genPopulation
    GENERATIONS.times do
      totalFit = evalAllFitness
      nextgen = []
      ngpop = 0
      while ngpop < POPSIZE
        child1 = select(totalFit)
        child2 = select(totalFit)
        crossover(child1, child2)
        mutate(child1)
        mutate(child2)
        nextgen << Chrom.new(child1, nil) << Chrom.new(child2, nil)
        ngpop += 2
      end
      @population = nextgen
    end
    evalAllFitness
    decode(findFittestChrom)
  end
end
