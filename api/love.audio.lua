---@class love.audio
---Provides an interface to create noise with the user's speakers.
local m = {}

--region Source
---@class Source : Object
---A Source represents audio you can play back. You can do interesting things with Sources, like set the volume, pitch, and its position relative to the listener.
local Source = {}
---Creates an identical copy of the Source in the stopped state.
---
---Static Sources will use significantly less memory and take much less time to be created if Source:clone is used to create them instead of love.audio.newSource, so this method should be preferred when making multiple Sources which play the same sound.
---
---Cloned Sources inherit all the set-able state of the original Source, but they are initialized stopped.
---@return Source
function Source:clone() end

---Returns the reference and maximum distance of the source.
---@return number, number
function Source:getAttenuationDistances() end

---Gets the number of channels in the Source. Only 1-channel (mono) Sources can use directional and positional effects.
---@return number
function Source:getChannelCount() end

---Gets the Source's directional volume cones. Together with Source:setDirection, the cone angles allow for the Source's volume to vary depending on its direction.
---@return number, number, number, number
function Source:getCone() end

---Gets the direction of the Source.
---@return number, number, number
function Source:getDirection() end

---Gets the duration of the Source. For streaming Sources it may not always be sample-accurate, and may return -1 if the duration cannot be determined at all.
---@param unit TimeUnit @The time unit for the return value.
---@return number
function Source:getDuration(unit) end

---Gets the filter settings associated to a specific Effect.
---
---This function returns nil if the Effect was applied with no filter settings associated to it.
---@param name string @The name of the effect.
---@param filtersettings table @An optional empty table that will be filled with the filter settings.
---@return table
function Source:getEffect(name, filtersettings) end

---Returns a list of all the active effects currently applied to the Source
---@return table
function Source:getActiveEffects() end

---Gets the filter settings currently applied to the Source.
---@param settings table @An optional empty table that will be filled with the filter settings.
---@return table
function Source:getFilter(settings) end

---Gets the number of free buffer slots of a queueable Source.
---@return number
function Source:getFreeBufferCount() end

---Gets the current pitch of the Source.
---@return number
function Source:getPitch() end

---Gets the position of the Source.
---@return number, number, number
function Source:getPosition() end

---Returns the rolloff factor of the source.
---@return number
function Source:getRolloff() end

---Gets the type (static or stream) of the Source.
---@return SourceType
function Source:getType() end

---Gets the velocity of the Source.
---@return number, number, number
function Source:getVelocity() end

---Gets the current volume of the Source.
---@return number
function Source:getVolume() end

---Returns the volume limits of the source.
---@return number, number
function Source:getVolumeLimits() end

---Returns whether the Source will loop.
---@return boolean
function Source:isLooping() end

---Returns whether the Source is playing.
---@return boolean
function Source:isPlaying() end

---Gets whether the Source's position and direction are relative to the listener.
---@return boolean
function Source:isRelative() end

---Pauses the Source.
function Source:pause() end

---Starts playing the Source.
---@return boolean
function Source:play() end

---Queues SoundData for playback in a queueable Source.
---
---This method requires the Source to be created via love.audio.newQueueableSource.
---@param sounddata SoundData @The data to queue. The SoundData's sample rate, bit depth, and channel count must match the Source's.
---@return boolean
function Source:queue(sounddata) end

---Sets the playing position of the Source.
---@param position number @The position to seek to.
---@param unit TimeUnit @The unit of the position value.
function Source:seek(position, unit) end

---Sets the reference and maximum distance of the source.
---@param ref number @The new reference distance.
---@param max number @The new maximum distance.
function Source:setAttenuationDistances(ref, max) end

---Sets the Source's directional volume cones. Together with Source:setDirection, the cone angles allow for the Source's volume to vary depending on its direction.
---@param innerAngle number @The inner angle from the Source's direction, in radians. The Source will play at normal volume if the listener is inside the cone defined by this angle.
---@param outerAngle number @The outer angle from the Source's direction, in radians. The Source will play at a volume between the normal and outer volumes, if the listener is in between the cones defined by the inner and outer angles.
---@param outerVolume number @The Source's volume when the listener is outside both the inner and outer cone angles.
---@param outerHighGain number @The gain for the high tones when the listener is outside both the inner and outer cone angles.
function Source:setCone(innerAngle, outerAngle, outerVolume, outerHighGain) end

---Sets the direction vector of the Source. A zero vector makes the source non-directional.
---@param x number @The X part of the direction vector.
---@param y number @The Y part of the direction vector.
---@param z number @The Z part of the direction vector.
function Source:setDirection(x, y, z) end

---Applies an audio effect to the Source.
---
---The effect must have been previously defined using love.audio.setEffect.
---@param name string @The name of the effect previously set up with love.audio.setEffect.
---@param enable boolean @If false and the given effect name was previously enabled on this Source, disables the effect.
---@return boolean
---@overload fun(name:string, filtersettings:table):boolean
function Source:setEffect(name, enable) end

---Sets a low-pass, high-pass, or band-pass filter to apply when playing the Source.
---@param settings table @The filter settings to use for this Source, with the following fields:
---@return boolean
function Source:setFilter(settings) end

---Sets whether the Source should loop.
---@param loop boolean @True if the source should loop, false otherwise.
function Source:setLooping(loop) end

---Sets the pitch of the Source.
---@param pitch number @Calculated with regard to 1 being the base pitch. Each reduction by 50 percent equals a pitch shift of -12 semitones (one octave reduction). Each doubling equals a pitch shift of 12 semitones (one octave increase). Zero is not a legal value.
function Source:setPitch(pitch) end

---Sets the position of the Source.
---@param x number @The X position of the Source.
---@param y number @The Y position of the Source.
---@param z number @The Z position of the Source.
function Source:setPosition(x, y, z) end

---Sets whether the Source's position and direction are relative to the listener. Relative Sources move with the listener so they aren't affected by it's position
---@param enable boolean @True to make the position, velocity, direction and cone angles relative to the listener, false to make them absolute.
function Source:setRelative(enable) end

---Sets the rolloff factor which affects the strength of the used distance attenuation.
---
---Extended information and detailed formulas can be found in the chapter "3.4. Attenuation By Distance" of OpenAL 1.1 specification.
---@param rolloff number @The new rolloff factor.
function Source:setRolloff(rolloff) end

---Sets the velocity of the Source.
---
---This does not change the position of the Source, but is used to calculate the doppler effect.
---@param x number @The X part of the velocity vector.
---@param y number @The Y part of the velocity vector.
---@param z number @The Z part of the velocity vector.
function Source:setVelocity(x, y, z) end

---Sets the volume of the Source.
---@param volume number @The volume of the Source, where 1.0 is normal volume.
function Source:setVolume(volume) end

---Sets the volume limits of the source. The limits have to be numbers from 0 to 1.
---@param min number @The minimum volume.
---@param max number @The maximum volume.
function Source:setVolumeLimits(min, max) end

---Stops a Source.
function Source:stop() end

---Gets the currently playing position of the Source.
---@param unit TimeUnit @The type of unit for the return value.
---@return number
function Source:tell(unit) end

--endregion Source
--region RecordingDevice
---@class RecordingDevice : Object
---Represents an audio input device capable of recording sounds.
local RecordingDevice = {}
---Gets the number of bits per sample in the data currently being recorded.
---@return number
function RecordingDevice:getBitDepth() end

---Gets the number of channels currently being recorded (mono or stereo).
---@return number
function RecordingDevice:getChannelCount() end

---Gets all recorded audio SoundData stored in the device's internal ring buffer.
---@return SoundData
function RecordingDevice:getData() end

---Gets the name of the recording device.
---@return string
function RecordingDevice:getName() end

---Gets the number of currently recorded samples.
---@return number
function RecordingDevice:getSampleCount() end

---Gets the number of samples per second currently being recorded.
---@return number
function RecordingDevice:getSampleRate() end

---Gets whether the device is currently recording.
---@return boolean
function RecordingDevice:isRecording() end

---Begins recording audio using this device.
---@param samplecount number @The maximum number of samples to store in an internal ring buffer when recording. RecordingDevice:getData clears the internal buffer when called.
---@param samplerate number @The number of samples per second to store when recording.
---@param bitdepth number @The number of bits per sample.
---@param channels number @Whether to record in mono or stereo. Most microphones don't support more than 1 channel.
---@return boolean
function RecordingDevice:start(samplecount, samplerate, bitdepth, channels) end

---Stops recording audio from this device.
---@return SoundData
function RecordingDevice:stop() end

--endregion RecordingDevice
---The different distance models.
---
---Extended information can be found in the chapter "3.4. Attenuation By Distance" of the OpenAL 1.1 specification.
DistanceModel = {
	---Sources do not get attenuated.
	['none'] = 1,
	---Inverse distance attenuation.
	['inverse'] = 2,
	---Inverse distance attenuation. Gain is clamped. In version 0.9.2 and older this is named inverse clamped.
	['inverseclamped'] = 3,
	---Linear attenuation.
	['linear'] = 4,
	---Linear attenuation. Gain is clamped. In version 0.9.2 and older this is named linear clamped.
	['linearclamped'] = 5,
	---Exponential attenuation.
	['exponent'] = 6,
	---Exponential attenuation. Gain is clamped. In version 0.9.2 and older this is named exponent clamped.
	['exponentclamped'] = 7,
}
---The different types of effects supported by love.audio.setEffect.
EffectType = {
	---Plays multiple copies of the sound with slight pitch and time variation. Used to make sounds sound "fuller" or "thicker".
	['chorus'] = 1,
	---Decreases the dynamic range of the sound, making the loud and quiet parts closer in volume, producing a more uniform amplitude throughout time.
	['compressor'] = 2,
	---Alters the sound by amplifying it until it clips, shearing off parts of the signal, leading to a compressed and distorted sound.
	['distortion'] = 3,
	---Decaying feedback based effect, on the order of seconds. Also known as delay; causes the sound to repeat at regular intervals at a decreasing volume.
	['echo'] = 4,
	---Adjust the frequency components of the sound using a 4-band (low-shelf, two band-pass and a high-shelf) equalizer.
	['equalizer'] = 5,
	---Plays two copies of the sound; while varying the phase, or equivalently delaying one of them, by amounts on the order of milliseconds, resulting in phasing sounds.
	['flanger'] = 6,
	---Decaying feedback based effect, on the order of milliseconds. Used to simulate the reflection off of the surroundings.
	['reverb'] = 7,
	---An implementation of amplitude modulation; multiplies the source signal with a simple waveform, to produce either volume changes, or inharmonic overtones.
	['ringmodulator'] = 8,
}
---The different types of waveforms that can be used with the ringmodulator EffectType.
EffectWaveform = {
	---A sawtooth wave, also known as a ramp wave. Named for its linear rise, and (near-)instantaneous fall along time.
	['sawtooth'] = 1,
	---A sine wave. Follows a trigonometric sine function.
	['sine'] = 2,
	---A square wave. Switches between high and low states (near-)instantaneously.
	['square'] = 3,
	---A triangle wave. Follows a linear rise and fall that repeats periodically.
	['triangle'] = 4,
}
---The different types of filters for Sources
FilterType = {
	---Low-pass filter. High frequency sounds are attenuated.
	['lowpass'] = 1,
	---High-pass filter. Low frequency sounds are attenuated.
	['highpass'] = 2,
	---Band-pass filter. Both high and low frequency sounds are attenuated based on the given parameters.
	['bandpass'] = 3,
}
---Types of audio sources.
---
---A good rule of thumb is to use stream for music files and static for all short sound effects. Basically, you want to avoid loading large files into memory at once.
SourceType = {
	---The whole audio is decoded.
	['static'] = 1,
	---The audio is decoded in chunks when needed.
	['stream'] = 2,
	---The audio must be manually queued by the user with Source:queue.
	['queue'] = 3,
}
---Units that represent time.
TimeUnit = {
	---Regular seconds.
	['seconds'] = 1,
	---Audio samples.
	['samples'] = 2,
}
---Gets a list of the names of the currently enabled effects.
---@return table
function m.getActiveEffects() end

---Gets the current number of simultaneously playing sources.
---@return number
function m.getActiveSourceCount() end

---Returns the distance attenuation model.
---@return DistanceModel
function m.getDistanceModel() end

---Gets the current global scale factor for velocity-based doppler effects.
---@return number
function m.getDopplerScale() end

---Gets the settings associated with an effect.
---@param name string @The name of the effect.
---@return table
function m.getEffect(name) end

---Gets the maximum number of active Effects, supported by the system.
---@return number
function m.getMaxSceneEffects() end

---Gets the maximum number of active Effects in a single Source object, that the system can support.
---@return number
function m.getMaxSourceEffects() end

---Returns the orientation of the listener.
---@return number, number, number, number, number, number
function m.getOrientation() end

---Returns the position of the listener.
---@return number, number, number
function m.getPosition() end

---Gets a list of RecordingDevices on the system. The first device in the list is the user's default recording device.
---
---If no device is available, it will return an empty list.
---Recording is not supported on iOS
---@return table
function m.getRecordingDevices() end

---Returns the number of sources which are currently playing or paused.
---@return number
function m.getSourceCount() end

---Returns the velocity of the listener.
---@return number, number, number
function m.getVelocity() end

---Returns the master volume.
---@return number
function m.getVolume() end

---Gets whether Effects are supported in the system.
---@return boolean
function m.isEffectsSupported() end

---Creates a new Source from a filepath, File, Decoder or SoundData. Sources created from SoundData are always static.
---@param filename string @The filepath to the audio file.
---@param type SourceType @Streaming or static source.
---@return Source
---@overload fun(file:File, type:SourceType):Source
---@overload fun(decoder:Decoder):Source
---@overload fun(fileData:FileData):Source
---@overload fun(soundData:SoundData):Source
function m.newSource(filename, type) end

---Creates a new Source usable for real-time generated sound playback with Source:queue.
---@param samplerate number @Number of samples per second when playing.
---@param bitdepth number @Bits per sample (8 or 16).
---@param channels number @1 for mono, 2 for stereo.
---@param buffercount number @The number of buffers that can be queued up at any given time with Source:queue. Cannot be greater than 64. A sensible default (~8) is chosen if no value is specified.
---@return Source
function m.newQueueableSource(samplerate, bitdepth, channels, buffercount) end

---Pauses currently played Sources.
---@overload fun(source:Source):void
function m.pause() end

---Plays the specified Source.
---@param source Source @The Source to play.
function m.play(source) end

---Sets the distance attenuation model.
---@param model DistanceModel @The new distance model.
function m.setDistanceModel(model) end

---Sets a global scale factor for velocity-based doppler effects. The default scale value is 1.
---@param scale number @The new doppler scale factor. The scale must be greater than 0.
function m.setDopplerScale(scale) end

---Defines an effect that can be applied to a Source.
---@param name string @The name of the effect.
---@param settings table @The settings to use for this effect, with the following fields:
---@return boolean
---@overload fun(name:string, enabled:boolean):boolean
function m.setEffect(name, settings) end

---Sets whether the system should mix the audio with the system's audio.
---@param mix boolean @True to enable mixing, false to disable it.
---@return boolean
function m.setMixWithSystem(mix) end

---Sets the orientation of the listener.
---@param fx number @The X component of the forward vector of the listener orientation.
---@param fy number @The Y component of the forward vector of the listener orientation.
---@param fz number @The Z component of the forward vector of the listener orientation.
---@param ux number @The X component of the up vector of the listener orientation.
---@param uy number @The Y component of the up vector of the listener orientation.
---@param uz number @The Z component of the up vector of the listener orientation.
function m.setOrientation(fx, fy, fz, ux, uy, uz) end

---Sets the position of the listener, which determines how sounds play.
---@param x number @The X position of the listener.
---@param y number @The Y position of the listener.
---@param z number @The Z position of the listener.
function m.setPosition(x, y, z) end

---Sets the velocity of the listener.
---@param x number @The X velocity of the listener.
---@param y number @The Y velocity of the listener.
---@param z number @The Z velocity of the listener.
function m.setVelocity(x, y, z) end

---Sets the master volume.
---@param volume number @1.0f is max and 0.0f is off.
function m.setVolume(volume) end

---Stops currently played sources.
---@overload fun(source:Source):void
function m.stop() end

return m