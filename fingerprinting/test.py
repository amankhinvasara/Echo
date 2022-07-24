import acoustid
import os
import ipfsapi

apikey = 'h1awJsR8dJ'

# gets file into local file temporarily for fingerprinting, and returns path
def get_file_content(cid):
	# read from ipfs from cid
	
	print('none')

# given cid, returns fingerprint of file in ipfs
def get_fingerprint(cid, testpath=None):
	os.environ['FPCALC'] = os.getcwd() + '/fpcalc'
	
	if testpath == None:
		path = get_file_content(cid)
	else:
		path = testpath
	
	res = acoustid.fingerprint_file(path)
	return res

if __name__ == '__main__':
	path = 'bruh.mp3'
	# fp = get_fingerprint('1234', path)

	client = ipfsapi.Client('127.0.0.1', 5001)
	res = client.add(path)
	print(res)
	# client.cat(res['Hash']) # read from ipfs


	# print(fp)