---@class love.data
---Provides functionality for creating and transforming data.
local m = {}

---Return type of various encoding and decoding functions.
ContainerType = {
	---Return type is Data.
	['data'] = 1,
	---Return type is string.
	['string'] = 2,
}
---Encoding format used to encode or decode data.
EncodeFormat = {
	---Encode/decode data as base64 binary-to-text encoding.
	['base64'] = 1,
	---Encode/decode data as hexadecimal string.
	['hex'] = 2,
}
---Hash algorithm of love.data.hash.
HashFunction = {
	---MD5 hash algorithm (16 bytes).
	['md5'] = 1,
	---SHA1 hash algorithm (20 bytes).
	['sha1'] = 2,
	---SHA2 hash algorithm with message digest size of 224 bits (28 bytes).
	['sha224'] = 3,
	---SHA2 hash algorithm with message digest size of 256 bits (32 bytes).
	['sha256'] = 4,
	---SHA2 hash algorithm with message digest size of 384 bits (48 bytes).
	['sha384'] = 5,
	---SHA2 hash algorithm with message digest size of 512 bits (64 bytes).
	['sha512'] = 6,
}
---Compresses a string or data using a specific compression algorithm.
---@param container ContainerType @What type to return the compressed data as.
---@param format CompressedDataFormat @The format to use when compressing the string.
---@param rawstring string @The raw (un-compressed) string to compress.
---@param level number @The level of compression to use, between 0 and 9. -1 indicates the default level. The meaning of this argument depends on the compression format being used.
---@return CompressedData or string
---@overload fun(container:ContainerType, format:CompressedDataFormat, data:Data, level:number):CompressedData or string
function m.compress(container, format, rawstring, level) end

---Decode Data or a string from any of the EncodeFormats to Data or string.
---@param containerType ContainerType @What type to return the decoded data as.
---@param format EncodeFormat @The format of the input data.
---@param sourceString string @The raw (encoded) data to decode.
---@return Variant
---@overload fun(containerType:ContainerType, format:EncodeFormat, sourceData:Data):Variant
function m.decode(containerType, format, sourceString) end

---Decompresses a CompressedData or previously compressed string or Data object.
---@param container ContainerType @What type to return the decompressed data as.
---@param compressedData CompressedData @The compressed data to decompress.
---@return string
---@overload fun(container:ContainerType, format:CompressedDataFormat, compressedstring:string):string
---@overload fun(container:ContainerType, format:CompressedDataFormat, data:Data):string
function m.decompress(container, compressedData) end

---Encode Data or a string to a Data or string in one of the EncodeFormats.
---@param containerType ContainerType @What type to return the encoded data as.
---@param format EncodeFormat @The format of the output data.
---@param sourceString string @The raw data to encode.
---@param lineLength number @The maximum line length of the output. Only supported for base64, ignored if 0.
---@return Variant
---@overload fun(containerType:ContainerType, format:EncodeFormat, sourceData:Data, lineLength:number):Variant
function m.encode(containerType, format, sourceString, lineLength) end

---Compute the message digest of a string using a specified hash algorithm.
---@param hashFunction HashFunction @Hash algorithm to use.
---@param string string @String to hash.
---@return string
---@overload fun(hashFunction:HashFunction, data:Data):string
function m.hash(hashFunction, string) end

return m