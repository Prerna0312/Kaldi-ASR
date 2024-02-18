import os
from fastapi import FastAPI, File, UploadFile,  Query
from model import model_obj, sr_module
import uvicorn
import io
import wave

api = FastAPI()

def convert_to_wav(audio_file):
    try:
        with wave.open('./te_audio.wav', 'wb') as f:
            f.setnchannels(1)  # set the number of channels (1 for mono, 2 for stereo)
            f.setsampwidth(2)  # set the sample width in bytes (2 bytes for 16-bit audio)
            f.setframerate(16000)  # set the sampling rate in Hz (44100 is common for CD-quality audio)
            f.writeframes(audio_file)
        return './te_audio.wav'
    except Exception as e:
        return {"Error with audio conversion" : str(e)} 

@api.post("/asr/")
def create_upload_file(audio_file: bytes = File(...)):
    lang_id = "te"

    wav_file = convert_to_wav(audio_file)
    with sr_module.AudioFile(wav_file) as source:
        audio = model_obj.record(source)
    asr_out = model_obj.recognize_google(audio, language=lang_id)
    print("asr_out:", asr_out)

    return {"transcription": asr_out}

if __name__ == "__main__":
    uvicorn.run(api, host="127.0.0.1", port=9000)
