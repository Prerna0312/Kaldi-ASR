import gradio as gr
from model import model_obj, sr_module
import wave 

def convert_to_wav(audio_f):
    try:
        with wave.open('./ui_audio.wav', 'wb') as f:
            f.setnchannels(1)  # set the number of channels (1 for mono, 2 for stereo)
            f.setsampwidth(2)  # set the sample width in bytes (2 bytes for 16-bit audio)
            f.setframerate(44000)  # set the sampling rate in Hz (44100 is common for CD-quality audio)
            f.writeframes(audio_f.frame_data)
    except Exception as e:
        return {"Error with audio conversion" : str(e)} 

def calling_asr(wav_file, lid):
    audio_file = sr_module.AudioData(wav_file[1].tobytes(), wav_file[0], 2)
    convert_to_wav(audio_file)
    text = model_obj.recognize_google(audio_file, language=lid)
    return text

def greet(audio):
    lid = "te"
    text = calling_asr(audio, lid) 
    return text

theme = "light"  # Set theme to light
title = "SPEECH TO TEXT CONVERTER"
description = "Automatic Speech Recognizer"  # Title bar text

demo = gr.Interface(fn=greet, inputs="audio", outputs="text", theme=theme, title=title, description=description)
demo.launch(debug=True, share=True)
