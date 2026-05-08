function fig2html(figFile, outHtml)

if nargin < 1
    [file, path] = uigetfile('*.fig');
    figFile = fullfile(path, file);
end

if nargin < 2
    outHtml = 'viewer.html';
end

% FIG aç
fig = openfig(figFile);
ax = findobj(fig, 'Type', 'axes');

% Surface veya patch bul
h = findobj(ax, 'Type', 'surface');
if isempty(h)
    h = findobj(ax, 'Type', 'patch');
end

if isempty(h)
    error('Surface veya patch bulunamadý.');
end

% Veri al
X = get(h, 'XData');
Y = get(h, 'YData');
Z = get(h, 'ZData');

% Mesh oluþtur
[nr, nc] = size(Z);
vertices = [X(:), Y(:), Z(:)];
faces = [];

for i = 1:nr-1
    for j = 1:nc-1
        v1 = (i-1)*nc + j;
        v2 = v1 + 1;
        v3 = v1 + nc;
        v4 = v3 + 1;
        
        faces = [faces;
            v1 v2 v3;
            v2 v4 v3];
    end
end

% JSON string
V = jsonencode(vertices);
F = jsonencode(faces-1); % JS 0-index

% HTML oluþtur
html = sprintf([...
'<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>3D Viewer</title>
<style>body{margin:0;}</style>
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/three@0.158/build/three.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/three@0.158/examples/js/controls/OrbitControls.js"></script>

<script>

const vertices = %s;
const faces = %s;

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(60, window.innerWidth/window.innerHeight, 0.1, 10000);

const renderer = new THREE.WebGLRenderer({antialias:true});
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

const geometry = new THREE.BufferGeometry();

let verts = [];
for(let v of vertices){
    verts.push(v[0], v[1], v[2]);
}

let indices = [];
for(let f of faces){
    indices.push(f[0], f[1], f[2]);
}

geometry.setAttribute('position', new THREE.Float32BufferAttribute(verts, 3));
geometry.setIndex(indices);
geometry.computeVertexNormals();

const material = new THREE.MeshStandardMaterial({
    color: 0x6699ff,
    side: THREE.DoubleSide
});

const mesh = new THREE.Mesh(geometry, material);
scene.add(mesh);

const light1 = new THREE.DirectionalLight(0xffffff, 1);
light1.position.set(1,1,1);
scene.add(light1);

const light2 = new THREE.AmbientLight(0x404040);
scene.add(light2);

camera.position.set(0,0, maxDim(vertices)*2);

const controls = new THREE.OrbitControls(camera, renderer.domElement);

function maxDim(v){
    let m=0;
    for(let p of v){
        m = Math.max(m, Math.abs(p[0]), Math.abs(p[1]), Math.abs(p[2]));
    }
    return m;
}

function animate(){
    requestAnimationFrame(animate);
    controls.update();
    renderer.render(scene, camera);
}
animate();

</script>
</body>
</html>'], V, F);

% Kaydet
fid = fopen(outHtml, 'w');
fwrite(fid, html);
fclose(fid);

disp(['HTML oluþturuldu: ', outHtml]);
end