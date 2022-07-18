<script>
	import { create } from 'ipfs-http-client';
	import AudioPlayer, { stopAll } from './AudioPlayer.svelte';

	/* Instance of the client */
	//const clientUrl = 'https://ipfs.infura.io:5001/api/v0';
	const client = create('https://ipfs.infura.io:5001/api/v0');

	$: artist = '';
	$: file = '';
	$: submitedForm = false;
	$: fileUrl = '';
	$: src = '';

	const onFormSubmit = async (e) => {
		e.preventDefault();
		console.log('submitting form...');
		console.log(artist);
		console.log(file);
		submitedForm = true;

		// var audio = new Audio(file);
		// audio.play();

		// var files = e.target.files;
		// src = URL.createObjectURL(files[0]);

		try {
			const added = await client.add(file);
			fileUrl = `https://ipfs.infura.io/ipfs/${added.path}`;
			console.log(added);
			console.log(fileUrl);
		} catch (error) {
			console.log('Error uploading file: ', error);
		}
		// let files = e.target.files;
		// console.log(e.target.files);
		// console.log(files);
		// src = URL.createObjectURL(files[0]);
	};
</script>

<html lang="en">
	<body class="body">
		<div class="container py-5 h-100">
			<div class="row d-flex justify-content-center align-items-center">
				<div class="col-lg-8 col-xl-6">
					<div class="card rounded-3">
						<div class="card-body p-4 p-md-5">
							{#if !submitedForm}
								<form on:submit={onFormSubmit}>
									<h3><span>Echo Music Upload</span></h3>

									<!-- Artist input -->
									<div class="form-outline mb-4">
										<label for="artist">Artist:</label>
										<input
											type="text"
											class="form-control"
											id="artist"
											placeholder="Artist"
											bind:value={artist}
											required
										/>
									</div>

									<!-- File Upload -->
									<div class="form-outline mb-4">
										<label for="formFile" class="form-label">Input Music File</label>
										<input
											bind:value={file}
											class="form-control"
											type="file"
											id="formFile"
											required
										/>
									</div>
									<!-- {#if loadedFile}
										<audio id="audio" controls>
											<source {src} id="src" />
										</audio>
									{/if} -->

									<!-- Submit button -->
									<div class="bottomButton">
										<div class="d-grid gap-2">
											<button type="submit" class="btn btn-primary" id="submit"> Submit </button>
										</div>
									</div>
								</form>
							{:else}
								<!-- <button on:click={stopAll}> Stop all! </button> -->

								<!-- {#each audioTracks as src}
									<AudioPlayer {src} />
								{/each}  -->

								<!-- <audio id="audio" controls>
                                    <source src={src} id="src" />
                                </audio> -->
							{/if}
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>

<svelte:head>
	<title>Echo</title>
</svelte:head>

<style>
	body {
		background-color: #9bd0ec;
	}

	h3 {
		font-size: 17px;
		width: 100%;
		text-align: left;
		border-bottom: 1px solid #000;
		line-height: 0.1em;
		margin: 10px 0 20px;
		padding-left: 5%;
		padding-top: 2%;
	}

	h3 span {
		background: #fff;
		padding: 0 10px;
	}
</style>
