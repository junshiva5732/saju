import random, subprocess, sys
from lunar_python import Solar
random.seed(7)
cases=[]
for _ in range(600):
    y=random.randint(1920,2035); m=random.randint(1,12); d=random.randint(1,28)
    H=random.randint(0,23); M=random.randint(0,59)
    cases.append((y,m,d,H,M))
# 절기 경계 근처 케이스 추가 (입춘/소한 등)
for y in range(1980,2030):
    for (m,d) in [(2,3),(2,4),(2,5),(1,5),(1,6),(3,5),(3,6),(12,7)]:
        for H in (0,6,12,18,23):
            cases.append((y,m,d,H,30))
inp='\n'.join(' '.join(map(str,c)) for c in cases)+'\n'
out=subprocess.run(['C:/flutter/bin/dart.bat','run','tool/verify_saju.dart'],input=inp,capture_output=True,text=True,encoding='utf-8')
if out.returncode: print(out.stderr); sys.exit(1)
dart={}
for line in out.stdout.splitlines():
    k,v=line.split(' => '); dart[k]=v
bad=0
for c in cases:
    k=' '.join(map(str,c))
    s=Solar.fromYmdHms(*c,0); ec=s.getLunar().getEightChar(); ec.setSect(1)
    ref=f"{ec.getYear()} {ec.getMonth()} {ec.getDay()} {ec.getTime()}"
    if dart.get(k)!=ref:
        bad+=1
        if bad<=15: print('MISMATCH',k,'dart=',dart.get(k),'ref=',ref)
print(f'{len(cases)} cases, {bad} mismatches')
