#!/usr/bin/env node

import childProcess from 'node:child_process';
import { promisify } from 'util';

const allowedSinks = ['PRO X Wireless Gaming Headset Analog Stereo', 'SoundCore 2']
const exec = promisify(childProcess.exec);

const switchInputToSink= async (inputId,sink) =>{
  await exec(`ponymix -t sink-input -d ${inputId} move ${sink}`)
}

const getInputIdsFromString = (inputString)=>{
  if (!inputString) return;

  const inputStrings = inputString.split(/\n(?=(sink-input))/g).filter(elem => elem!=="sink-input")
  const inputIds = inputStrings.map(inputString =>{
    const lines = inputString.split('\n')
    const id = lines[0].split(' ')[1].split(":")[0]
    return id
  })
  return inputIds
}

const switchDefaultSink = async ()=>{
  const currentDefaultId = (await exec('ponymix defaults')).stdout[5]
  const newSinkId = sinks.find(sink => sink.id !== currentDefaultId )?.id
  if (!newSinkId) return
  await exec(`ponymix set-default -d ${newSinkId}`)
  return newSinkId
}

//get all audio outputs
const listSinksCmd = await exec('ponymix -t sink list')
const sinkStrings = listSinksCmd.stdout.split(/\n(?=(sink))/g).filter(elem => elem!=="sink")
const sinks = sinkStrings
  .map((sinkString) => {
    const [idLine,nameLine,volumeLine] = sinkString.split("\n")
    const id = idLine[5]
    const name = nameLine.trim()
    return { id, name, volume:volumeLine }
  })
  .filter(sink => allowedSinks.includes(sink.name))

//get all running apps (inputs)...
const listInputsCmd = await exec('ponymix list -t sink-input')
const inputIds = getInputIdsFromString(listInputsCmd?.stdout)

const newSinkId = await switchDefaultSink()
if ( newSinkId ){
  //...and switch them to the new sink (audio output)
  inputIds?.forEach(inputId => switchInputToSink(inputId, newSinkId))
}
