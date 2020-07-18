---@class StateStack
StateStack = Class {}

function StateStack:init(states)
    self.states = states or {} ---@type BaseState[]
end

function StateStack:push(state, stateEnterParams)
    table.insert(self.states, #self.states, state)
    self.states[#self.states]:enter(stateEnterParams)
end

function StateStack:pop()
    self.states[#self.states]:exit()
    table.remove(self.states, #self.states)
end

---@return BaseState
function StateStack:getActiveState()
    return self.states[#self.states]
end
