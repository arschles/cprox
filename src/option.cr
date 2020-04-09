module Cprox
    class Option(T)
        def initialize(@var : T | Nil)
        end

        def map(&block: T -> U) : Option(U) forall U
            if @val.nil?
                return Option.new(Nil)
            else
                new_val: U = yield @val
                return Option.new(new_val)
            end
        end

        def if_full(&full: T -> U) forall U
            if @val.nil?
            else
                yield @val
            end
        end

        def if_nil(&empty: Nil -> U) forall U
            if @val.nil?
                yield
            end
        end
    end
end