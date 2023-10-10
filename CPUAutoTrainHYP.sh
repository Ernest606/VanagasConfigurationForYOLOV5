#!/bin/bash
#SBATCH --job-name=YV5Train
#SBATCH --constraint=i7-4790
#SBATCH --output=/home/simona/SAMPLE/GPU/YoloMokymas/tempOutputCPU.log
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --time=999:99:99

# Procesu kiekis, lygiagreciam darbui
######SBATCH --ntasks=2

source /home/simona/SAMPLE/Python-3.9.9/virtualenv-1.9/python3.9_venv/bin/activate
GIT_PYTHON_GIT_EXECUTABLE=/opt/rocks/bin/git
export GIT_PYTHON_GIT_EXECUTABLE

python3 /home/simona/SAMPLE/GPU/EditingCSVforHYP.py #CSV failo redagavimas

while IFS=";" read -r MODELNR EPOCHS LR0 MOMENTUM WEIGHT_DECAY WEIGHTS
do
  (
  date;hostname;pwd

  pip install torch torchvision torchaudio
  cd /home/simona/SAMPLE/GPU/YoloMokymas/
  git clone https://github.com/ultralytics/yolov5
  cd /home/simona/SAMPLE/GPU/YoloMokymas/yolov5
  pip3 install -r requirements.txt
  pip install discordwebhook
  pip install GitPython
  
  MIX="MIX"
  WHITE="WHITE"
  NEUTRAL="NEUTRAL"
  
  python3 /home/simona/SAMPLE/GPU/EditingHYPFile.py $LR0 $MOMENTUM $WEIGHT_DECAY #.yaml failo su hyperparametrais redagavimas
  IFS="." read -r WEIGHTSCLEAR DOTPT <<< "$WEIGHTS"
  NAME=$MODELNR"_"$WEIGHTSCLEAR"_"$LR0"_"$MOMENTUM"_"$WEIGHT_DECAY
  
  echo "Displaying Model-$MODELNR"
  echo "Img: 320"
  echo "Batch: 32"
  echo "Epochs: $EPOCHS"
  echo "Data: dataset.yaml"
  echo "Weights: $WEIGHTSCLEAR"
  echo "Device: CPU"
  echo "__________________________________"
  echo "HYP:"
  echo "lr0: $LR0"
  echo "momentum: $MOMENTUM"
  echo "weight_decay: $WEIGHT_DECAY"
  echo ""

  python3 /home/simona/SAMPLE/GPU/YoloMokymas/yolov5/train.py \
		--cache \
		--freeze 10 \
		--patience 50 \
		--img 320 \
		--batch 32 \
		--epochs $EPOCHS \
		--data /home/simona/SAMPLE/GPU/YoloMokymas/yolov5/dataset.yaml \
		--weights /home/simona/SAMPLE/GPU/YoloMokymas/yolov5/runs/train/AutomaticModels/Archive/135Models/$NAME/weights/last.pt \
		--name AutomaticModels/$NAME

  (
	date
	python3 confusionDetect.py \
	--weights /home/simona/SAMPLE/GPU/YoloMokymas/yolov5/runs/train/AutomaticModels/${NAME}/weights/best.pt \
	--source /home/simona/SAMPLE/GPU/YoloMokymas/data/testMIX
  ) 2>&1 | tee -a /home/simona/SAMPLE/GPU/YoloMokymas/DetectAutomaticLogs/DETECT_${NAME}_MIX.log

  (
	date
	python3 confusionDetect.py \
	--weights /home/simona/SAMPLE/GPU/YoloMokymas/yolov5/runs/train/AutomaticModels/${NAME}/weights/best.pt \
	--source /home/simona/SAMPLE/GPU/YoloMokymas/data/testNEUTRAL
  ) 2>&1 | tee -a /home/simona/SAMPLE/GPU/YoloMokymas/DetectAutomaticLogs/DETECT_${NAME}_NEUTRAL.log

  (
	date
	python3 confusionDetect.py \
	--weights /home/simona/SAMPLE/GPU/YoloMokymas/yolov5/runs/train/AutomaticModels/${NAME}/weights/best.pt \
	--source /home/simona/SAMPLE/GPU/YoloMokymas/data/testWHITE
  ) 2>&1 | tee -a /home/simona/SAMPLE/GPU/YoloMokymas/DetectAutomaticLogs/DETECT_${NAME}_WHITE.log

  mkdir /home/simona/SAMPLE/GPU/YoloMokymas/DetectAutomaticLogs/ConfusionMatrix/$NAME
  ( 
	RESULTMIX=`python3 /home/simona/SAMPLE/GPU/confusionDetectToResult.py $NAME $MIX`
	IFS=" " read -r MIX_POSITIVE MIX_ALL MIX_DOTPT <<< "$RESULTMIX"
	
	RESULTNEUTRAL=`python3 /home/simona/SAMPLE/GPU/confusionDetectToResult.py $NAME $NEUTRAL`
	IFS=" " read -r NEUTRAL_POSITIVE NEUTRAL_ALL NEUTRAL_DOTPT <<< "$RESULTNEUTRAL"
	
	RESULTWHITE=`python3 /home/simona/SAMPLE/GPU/confusionDetectToResult.py $NAME $WHITE`
	IFS=" " read -r WHITE_POSITIVE WHITE_ALL WHITE_DOTPT <<< "$RESULTWHITE"
	
	echo $NAME
	echo "MIX \/"
	echo $MIX_POSITIVE
	echo $MIX_ALL
	echo $RESULTMIX
	echo "NEUTRAL \/"
	echo $NEUTRAL_POSITIVE
	echo $NEUTRAL_ALL
	echo $RESULTNEUTRAL
	echo "WHITE \/"
	echo $WHITE_POSITIVE
	echo $WHITE_ALL
	echo $RESULTWHITE
	
	python3 /home/simona/SAMPLE/GPU/saveDetectResCSV.py $NAME $MIX_POSITIVE $NEUTRAL_POSITIVE $WHITE_POSITIVE
	python3 /home/simona/SAMPLE/GPU/confusionDiscord.py $NAME $RESULTMIX $RESULTNEUTRAL $RESULTWHITE
	
  ) 2>&1 | tee -a /home/simona/SAMPLE/GPU/YoloMokymas/DetectAutomaticLogs/Result_${NAME}.log 
  
  CHECKQUEUE=`squeue |grep gpu-0-0 |wc -l`
  if [ $CHECKQUEUE -eq 0 ]
  then
	ssh simona@vanagas sbatch /home/simona/SAMPLE/GPU/YoloMokymas/GPUAutoTrainHYP.sh
  else
    ssh simona@vanagas sbatch /home/simona/SAMPLE/GPU/YoloMokymas/CPUAutoTrainHYP.sh
  fi
  
  rm -r /home/simona/SAMPLE/GPU/YoloMokymas/yolov5/runs/detect
  echo "BAIGEME DARBA!"
  date
  hostname
  exit
  ) 2>&1 | tee -a /home/simona/SAMPLE/GPU/YoloMokymas/AutomaticLogs/LOG_${MODELNR}_${WEIGHTSCLEAR}_${LR0}_${MOMENTUM}_${WEIGHT_DECAY}.log   # Logu išsaugojimas
done < <(head -n 2 /home/simona/SAMPLE/GPU/YoloMokymas/ModelsHYP.csv | tail -n 1)  # CSV failo su modeliais apmokymui nuskaitymas