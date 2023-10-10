from discordwebhook import Discord
import sys

discord = Discord(url="https://discord.com/api/webhooks/1145315351341584397/IX5sWaubh4LkeC8yD2b4y9LG1PiTktktNFUVkrnmLT8RLzli_rlJ1IMJPyCxVDs-NxH_")

visoModeliu="135"
name=sys.argv[1]
allImg="3300"
confMatrPathMIX='/home/simona/SAMPLE/GPU/YoloMokymas/DetectAutomaticLogs/ConfusionMatrix/' + name + '/MIX.jpg'
confMatrPathNEUTRAL='/home/simona/SAMPLE/GPU/YoloMokymas/DetectAutomaticLogs/ConfusionMatrix/' + name + '/NEUTRAL.jpg'
confMatrPathWHITE='/home/simona/SAMPLE/GPU/YoloMokymas/DetectAutomaticLogs/ConfusionMatrix/' + name + '/WHITE.jpg'

allPositive=int(sys.argv[2])+int(sys.argv[26])+int(sys.argv[50])

confMIX=[]
for x in range(4, 26):
    confMIX.append(sys.argv[x].split(':')[1])   

confNEUTRAL=[]
for x in range(28, 50):
    confNEUTRAL.append(sys.argv[x].split(':')[1])   

confWHITE=[]
for x in range(52, 74):
    confWHITE.append(sys.argv[x].split(':')[1])   

MOKYMASBAIGTAS="Modelis " + name.split('_')[0] + " iš " + visoModeliu + "\n" + name

HYP="Weights= " + name.split('_')[1] +"\n\
lr0= " + name.split('_')[2] +"\n\
momentum= " + name.split('_')[3] +"\n\
weight_decay: " + name.split('_')[4]

TESTAVIMAS="MIX - Atpažinta " + sys.argv[2] + " iš " + sys.argv[3] + "\n\
NEUTRAL - Atpažinta " + sys.argv[26] + " iš " + sys.argv[27] + "\n\
WHITE - Atpažinta " + sys.argv[50] + " iš " + sys.argv[51] + "\n\
Bendrai - Atpažinta " + str(allPositive) + " iš " + allImg

AVGConfusion="\
1x1_h2: " + confMIX[0] + " - " + confNEUTRAL[0] + " - " + confWHITE[0] + "\n\
1x1_h2_round: " + confMIX[1] + " - " + confNEUTRAL[1] + " - " + confWHITE[1] + "\n\
1x1_h2_trap: " + confMIX[2] + " - " + confNEUTRAL[2] + " - " + confWHITE[2] + "\n\
1x2_h2: " + confMIX[3] + " - " + confNEUTRAL[3] + " - " + confWHITE[3] + "\n\
1x2_h2_trap: " + confMIX[4] + " - " + confNEUTRAL[4] + " - " + confWHITE[4] + "\n\
1x2_h3: " + confMIX[5] + " - " + confNEUTRAL[5] + " - " + confWHITE[5] + "\n\
1x2_h4: " + confMIX[6] + " - " + confNEUTRAL[6] + " - " + confWHITE[6] + "\n\
1x4_h2: " + confMIX[7] + " - " + confNEUTRAL[7] + " - " + confWHITE[7] + "\n\
1x6_h2: " + confMIX[8] + " - " + confNEUTRAL[8] + " - " + confWHITE[8] + "\n\
2x2_h1: " + confMIX[9] + " - " + confNEUTRAL[9] + " - " + confWHITE[9] + "\n\
2x2_h2: " + confMIX[10] + " - " + confNEUTRAL[10] + " - " + confWHITE[10] + "\n\
2x2_h2_trap: " + confMIX[11] + " - " + confNEUTRAL[11] + " - " + confWHITE[11] + "\n\
2x3_h1: " + confMIX[12] + " - " + confNEUTRAL[12] + " - " + confWHITE[12] + "\n\
2x3_h2: " + confMIX[13] + " - " + confNEUTRAL[13] + " - " + confWHITE[13] + "\n\
2x4_h1: " + confMIX[14] + " - " + confNEUTRAL[14] + " - " + confWHITE[14] + "\n\
2x4_h2: " + confMIX[15] + " - " + confNEUTRAL[15] + " - " + confWHITE[15] + "\n\
2x6_h1: " + confMIX[16] + " - " + confNEUTRAL[16] + " - " + confWHITE[16] + "\n\
2x6_h2: " + confMIX[17] + " - " + confNEUTRAL[17] + " - " + confWHITE[17] + "\n\
2x8_h1: " + confMIX[18] + " - " + confNEUTRAL[18] + " - " + confWHITE[18] + "\n\
4x4_h1: " + confMIX[19] + " - " + confNEUTRAL[19] + " - " + confWHITE[19] + "\n\
4x6_h1: " + confMIX[20] + " - " + confNEUTRAL[20] + " - " + confWHITE[20] + "\n\
4x8_h1: " + confMIX[21] + " - " + confNEUTRAL[21] + " - " + confWHITE[21]


discord.post(
    username="Vanagas",
    avatar_url="https://yt3.googleusercontent.com/ytc/AOPolaRT0H8JRpXNtX2rI5B9TzUWbIZIV8FahCzztsvWSQ=s900-c-k-c0x00ffffff-no-rj",
    embeds=[
        {
            "title": "Mokymas baigtas",
            "description": MOKYMASBAIGTAS,
            "fields": [
                {"name": "Hyperparametrai", "value": HYP, "inline": True},
                {"name": "Testavimas", "value": TESTAVIMAS},
                {"name": "AVG conf TruePositive MIX - NEUTRAL - WHITE", "value": AVGConfusion},
            ],
        }
    ],
    file={
        "file1": open(confMatrPathMIX, "rb"),
        "file2": open(confMatrPathNEUTRAL, "rb"),
        "file3": open(confMatrPathWHITE, "rb"),
    },
)