#!/bin/bash
cd /home/segmind/NPCI/k0/egs/telugu_asr/asr
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  echo -n '# '; cat <<EOF
compute-mfcc-feats --write-utt2dur=ark,t:exp/make_mfcc/test/utt2dur.${SGE_TASK_ID} --verbose=2 --config=conf/mfcc.conf scp,p:exp/make_mfcc/test/wav_test.${SGE_TASK_ID}.scp ark:- | copy-feats --write-num-frames=ark,t:exp/make_mfcc/test/utt2num_frames.${SGE_TASK_ID} --compress=true ark:- ark,scp:/home/segmind/NPCI/k0/egs/telugu_asr/asr/mfcc/raw_mfcc_test.${SGE_TASK_ID}.ark,/home/segmind/NPCI/k0/egs/telugu_asr/asr/mfcc/raw_mfcc_test.${SGE_TASK_ID}.scp 
EOF
) >exp/make_mfcc/test/make_mfcc_test.$SGE_TASK_ID.log
time1=`date +"%s"`
 ( compute-mfcc-feats --write-utt2dur=ark,t:exp/make_mfcc/test/utt2dur.${SGE_TASK_ID} --verbose=2 --config=conf/mfcc.conf scp,p:exp/make_mfcc/test/wav_test.${SGE_TASK_ID}.scp ark:- | copy-feats --write-num-frames=ark,t:exp/make_mfcc/test/utt2num_frames.${SGE_TASK_ID} --compress=true ark:- ark,scp:/home/segmind/NPCI/k0/egs/telugu_asr/asr/mfcc/raw_mfcc_test.${SGE_TASK_ID}.ark,/home/segmind/NPCI/k0/egs/telugu_asr/asr/mfcc/raw_mfcc_test.${SGE_TASK_ID}.scp  ) 2>>exp/make_mfcc/test/make_mfcc_test.$SGE_TASK_ID.log >>exp/make_mfcc/test/make_mfcc_test.$SGE_TASK_ID.log
ret=$?
time2=`date +"%s"`
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>exp/make_mfcc/test/make_mfcc_test.$SGE_TASK_ID.log
echo '#' Finished at `date` with status $ret >>exp/make_mfcc/test/make_mfcc_test.$SGE_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch exp/make_mfcc/test/q/sync/done.334127.$SGE_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# qsub -v PATH -cwd -S /bin/bash -j y -l arch=*64* -o exp/make_mfcc/test/q/make_mfcc_test.log   -t 1:1 /home/segmind/NPCI/k0/egs/telugu_asr/asr/exp/make_mfcc/test/q/make_mfcc_test.sh >>exp/make_mfcc/test/q/make_mfcc_test.log 2>&1
